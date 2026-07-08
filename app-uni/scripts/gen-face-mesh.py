# -*- coding: utf-8 -*-
# 生成首页取景意象:MediaPipe canonical face model(468 点官方拓扑)正交投影 → 人脸三角网格 SVG。
#
# 用法:
#   python scripts/gen-face-mesh.py    → 覆盖 src/static/face-scan.svg
#   同时写预览数据到 <系统临时目录>/face-mesh-preview.json(紧凑 JSON,供可视化重建)。
#
# 数据源(Apache-2.0 © Google,已缓存供离线重跑):
#   scripts/data/canonical_face_model.obj
#   来自 https://raw.githubusercontent.com/google-ai-edge/mediapipe/master/
#        mediapipe/modules/face_geometry/data/canonical_face_model.obj
#   obj 顶点顺序 = MediaPipe landmark 索引(v 第 k 行 ↔ landmark k-1),468 顶点 / 898 三角面。
#
# 投影与画布:
#   正交投影 x2d = x, y2d = -y(y 翻转成屏幕坐标,忽略 z);
#   viewBox 0 0 416 500(显示框 208×250 的 2 倍,整数坐标即有 0.5px 显示精度);
#   等比缩放 scale = min(304/bboxH, 240/bboxW),中心对齐 (208, 240)
#   (按高度限制时脸恰好落在 y≈88 顶 ~ y≈392 下巴;按宽度限制时围绕 y=240 垂直居中)。
#
# 描边色取自 design-tokens(ADR 0007):rose-wood #8C4A3A / gold #C9913F。
# 改 token / 调参(缩放、颜色、金点索引)后重跑本脚本即可。
# 扫描光带由 index.vue 的 .stage__scan 用 CSS 叠加,不在此文件。
import json
import os
import tempfile
from collections import defaultdict

SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
OBJ_PATH = os.path.join(SCRIPT_DIR, "data", "canonical_face_model.obj")
OUT_PATH = os.path.normpath(os.path.join(SCRIPT_DIR, "..", "src", "static", "face-scan.svg"))
PREVIEW_PATH = os.path.join(tempfile.gettempdir(), "face-mesh-preview.json")

# 画布参数(2x 空间)
VIEW_W, VIEW_H = 416, 500
CENTER_X, CENTER_Y = 208, 240   # 脸包围盒中心对齐点
FIT_W, FIT_H = 240, 304         # 宽/高预算(304 = 392 - 88)

# 金色 landmark 点(MediaPipe 0-based 索引):
# 33/133 右眼外/内角、362/263 左眼内/外角、1 鼻尖、61/291 嘴角、105/334 左右眉中、152 下巴底
GOLD_LANDMARKS = [33, 133, 362, 263, 1, 61, 291, 105, 334, 152]


def parse_obj(path):
    """解析 obj:v 行取 x,y,z;f 行取 '/' 前的 1-based 顶点索引(转 0-based)。"""
    verts = []
    faces = []
    with open(path, "r", encoding="utf-8") as fh:
        for line in fh:
            parts = line.split()
            if not parts:
                continue
            if parts[0] == "v":
                verts.append((float(parts[1]), float(parts[2]), float(parts[3])))
            elif parts[0] == "f":
                idx = [int(tok.split("/")[0]) - 1 for tok in parts[1:]]
                # canonical 模型全是三角面;若遇多边形则扇形剖分兜底
                for k in range(1, len(idx) - 1):
                    faces.append((idx[0], idx[k], idx[k + 1]))
    return verts, faces


def project_and_fit(verts):
    """正交投影(x, -y)后等比缩放平移进 viewBox,返回浮点坐标列表。"""
    pts = [(x, -y) for (x, y, _z) in verts]
    min_x = min(p[0] for p in pts)
    max_x = max(p[0] for p in pts)
    min_y = min(p[1] for p in pts)
    max_y = max(p[1] for p in pts)
    bbox_w = max_x - min_x
    bbox_h = max_y - min_y
    scale = min(FIT_H / bbox_h, FIT_W / bbox_w)   # 等比,禁止拉伸
    src_cx = (min_x + max_x) / 2
    src_cy = (min_y + max_y) / 2
    return [
        (CENTER_X + (x - src_cx) * scale, CENTER_Y + (y - src_cy) * scale)
        for (x, y) in pts
    ]


def collect_edges(faces):
    """去重边集合 + 每条边所属三角形计数(找边界用)。"""
    edge_count = defaultdict(int)
    for a, b, c in faces:
        for i, j in ((a, b), (b, c), (c, a)):
            edge_count[(min(i, j), max(i, j))] += 1
    return edge_count


def trace_boundary_loops(edge_count):
    """把只属于一个三角形的边串成闭环;返回环列表(顶点索引序列)。"""
    boundary = {e for e, n in edge_count.items() if n == 1}
    adj = defaultdict(list)
    for a, b in boundary:
        adj[a].append(b)
        adj[b].append(a)
    remaining = set(boundary)
    loops = []
    while remaining:
        a, b = remaining.pop()
        loop = [a, b]
        while True:
            cur = loop[-1]
            nxt = None
            for n in adj[cur]:
                e = (min(cur, n), max(cur, n))
                if e in remaining:
                    nxt = n
                    remaining.remove(e)
                    break
            if nxt is None:
                break
            loop.append(nxt)
        # 闭环最后会走回起点,去掉重复的收尾顶点
        if len(loop) > 1 and loop[0] == loop[-1]:
            loop.pop()
        loops.append(loop)
    return loops


def ri(v):
    return int(round(v))


def build_svg(P, edges, outer_loop, gold_pts):
    """按 注释 → 角标 → 底衬 → 网格 → 外轮廓 → 金点 顺序拼 SVG。"""
    outline_d = "M" + " L".join(f"{ri(P[i][0])} {ri(P[i][1])}" for i in outer_loop) + " Z"
    mesh_d = "".join(
        f"M{ri(P[i][0])} {ri(P[i][1])}L{ri(P[j][0])} {ri(P[j][1])}"
        for i, j in edges
    )
    circles = "".join(f'<circle cx="{ri(x)}" cy="{ri(y)}" r="3.6"/>' for x, y in gold_pts)
    return f'''<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 {VIEW_W} {VIEW_H}">
  <!-- 首页取景意象:MediaPipe canonical face model(468 点)正交投影,官方三角拓扑;
       数据 Apache-2.0 © Google;由 scripts/gen-face-mesh.py 生成。
       描边色取自 design-tokens(ADR 0007):rose-wood #8C4A3A / gold #C9913F,改 token 需重跑。
       扫描光带由 index.vue 的 .stage__scan 用 CSS 叠加,不在此文件。 -->
  <g stroke="#FFFFFF" stroke-opacity="0.75" stroke-width="4" stroke-linecap="round" fill="none">
    <path d="M32 68 L32 32 L68 32"/><path d="M348 32 L384 32 L384 68"/>
    <path d="M32 432 L32 468 L68 468"/><path d="M348 468 L384 468 L384 432"/>
  </g>
  <path d="{outline_d}" fill="#FBECE0" fill-opacity="0.12"/>
  <path d="{mesh_d}" stroke="#8C4A3A" stroke-opacity="0.28" stroke-width="0.9" stroke-linecap="round" fill="none"/>
  <path d="{outline_d}" fill="none" stroke="#8C4A3A" stroke-opacity="0.55" stroke-width="2.4" stroke-linejoin="round"/>
  <g fill="#C9913F">{circles}</g>
</svg>
'''


def main():
    verts, faces = parse_obj(OBJ_PATH)
    P = project_and_fit(verts)
    edge_count = collect_edges(faces)
    edges = sorted(edge_count.keys())
    loops = trace_boundary_loops(edge_count)
    outer_loop = max(loops, key=len)   # 最长边界环 = 脸外轮廓;其余是眼/嘴孔,保留不处理

    gold_pts = [P[i] for i in GOLD_LANDMARKS]
    svg = build_svg(P, edges, outer_loop, gold_pts)
    with open(OUT_PATH, "w", encoding="utf-8", newline="\n") as fh:
        fh.write(svg)
    svg_bytes = len(svg.encode("utf-8"))

    stats = {
        "vertices": len(verts),
        "faces": len(faces),
        "edges": len(edges),
        "boundary_loops": len(loops),
        "loop_sizes": sorted((len(l) for l in loops), reverse=True),
        "svg_bytes": svg_bytes,
    }
    preview = {
        "P": [[ri(x), ri(y)] for x, y in P],
        "E": [[i, j] for i, j in edges],
        "O": list(outer_loop),
        "G": [[ri(x), ri(y)] for x, y in gold_pts],
        "stats": stats,
    }
    with open(PREVIEW_PATH, "w", encoding="utf-8") as fh:
        json.dump(preview, fh, separators=(",", ":"))

    print("vertices", stats["vertices"], "faces", stats["faces"],
          "edges", stats["edges"], "boundary_loops", stats["boundary_loops"],
          "loop_sizes", stats["loop_sizes"], "svg_bytes", svg_bytes)
    print("out:", OUT_PATH)
    print("preview:", PREVIEW_PATH)
    # 金点 sanity check:鼻尖(1) x 应 ≈208;下巴底(152) y 应是这批点里最大
    for idx, (x, y) in zip(GOLD_LANDMARKS, gold_pts):
        print(f"gold[{idx}] = ({x:.1f}, {y:.1f})")


if __name__ == "__main__":
    main()
