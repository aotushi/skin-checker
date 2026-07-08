import { Validator } from '@cfworker/json-schema'
import schema from '../../shared/skin-report.schema.json'

// 契约校验:以 shared/skin-report.schema.json(SSOT)校验 LLM 返回值。
// 用 @cfworker/json-schema 而非 ajv —— ajv 默认走运行时代码生成(动态编译 schema),
// Workers 生产环境禁 eval;本库纯运行时求值、原生支持 draft 2020-12。
// validator 是模块级不变配置(schema 的编译产物),非请求态,可安全常驻。
// 第三参 shortCircuit=false:收集全部错误,不在首个错误处停。
const validator = new Validator(schema as unknown as Record<string, unknown>, '2020-12', false)

export interface ValidateResult {
  valid: boolean
  /** 形如 "/skinAxes/oilDry/value <原因>" 的可读错误行 */
  errors: string[]
}

/** 校验一份候选报告是否符合 SkinReport 契约(含 enum / pattern / min-max)。 */
export function validateReport(data: unknown): ValidateResult {
  const res = validator.validate(data)
  if (res.valid) return { valid: true, errors: [] }
  return {
    valid: false,
    errors: res.errors.map((e) => `${e.instanceLocation || '/'} ${e.error}`),
  }
}
