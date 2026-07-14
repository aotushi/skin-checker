import type { SkinReport } from './types/skin-report'

// 平台适配层:同一套业务(app.ts)映射两个部署目标 —— Cloudflare Workers 与 阿里云 FC
// (Web 函数),平台差异收敛到本接口,由各自入口实现(index.ts / index.fc.ts,见 ADR 0010)。

/** 一条检测历史(读回形状,两平台共用;FC 侧 V2 前恒为空列表)。 */
export interface HistoryRow {
  id: string
  createdAt: number
  skinTypeCode: string
  skinTypeName: string
  report: SkinReport
}

/** 上传图片的字节及其清理句柄。 */
export interface StashedImage {
  bytes: ArrayBuffer
  /**
   * 分析结束(无论成败)后调用;不应抛错,平台实现自行兜底记日志。
   * Workers 删 R2 临时对象(ADR 0003);FC 内存直读,无事可做。
   */
  cleanup(): Promise<void>
}

/** 平台注入的依赖:图片暂存、历史落库、密钥来源。 */
export interface PlatformDeps {
  /**
   * 拿到上传图片的字节。Workers 走 R2 暂存中转(ADR 0003);
   * FC 内存直读、不落任何存储 —— 同样满足「分析后不留存」承诺。
   */
  stashImage(file: File): Promise<StashedImage>
  /** 落一条结构化历史。Workers 写 D1;FC 为 no-op(前端历史在本地,后端历史属 V2 用户体系预留)。 */
  saveReport(id: string, createdAt: number, report: SkinReport): Promise<void>
  /** 历史列表,时间倒序。FC 恒返回空数组(V2 前)。 */
  listHistory(): Promise<HistoryRow[]>
  /** 千问 API key;空串走 mock(不真调、不计费)。 */
  qwenApiKey: string
}
