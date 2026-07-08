// R2 临时图片:上传中转,分析后即删(ADR 0003)。key 前缀 tmp/ + crypto.randomUUID()。

const TMP_PREFIX = 'tmp/'

/** 存一张临时图片,返回 R2 object key。 */
export async function putTempImage(bucket: R2Bucket, file: File): Promise<string> {
  const key = `${TMP_PREFIX}${crypto.randomUUID()}`
  await bucket.put(key, file.stream(), {
    httpMetadata: { contentType: file.type || 'application/octet-stream' },
  })
  return key
}

/** 读回临时图片字节(供多模态分析);不存在返回 null。 */
export async function getTempImageBytes(bucket: R2Bucket, key: string): Promise<ArrayBuffer | null> {
  const obj = await bucket.get(key)
  return obj ? await obj.arrayBuffer() : null
}

/** 删除临时图片(分析后即删,ADR 0003)。 */
export async function deleteTempImage(bucket: R2Bucket, key: string): Promise<void> {
  await bucket.delete(key)
}
