import type { ValidationAcceptor, ValidationChecks } from 'langium';
import type { K3AstType, KCode } from './generated/ast.js';
import type { K3Services } from './k3-module.js';

/**
 * Register custom validation checks.
 */
export function registerValidationChecks(services: K3Services) {
    const registry = services.validation.ValidationRegistry;
    const validator = services.validation.K3Validator;
    const checks: ValidationChecks<K3AstType> = {
        KCode: validator.checkCode
    };
    registry.register(checks, validator);
}

/**
 * Implementation of custom validations.
 */
export class K3Validator {

    checkCode(code: KCode, accept: ValidationAcceptor): void {
        // TODO
    }

}
