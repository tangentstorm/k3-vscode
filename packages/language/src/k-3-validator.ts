import type { ValidationAcceptor, ValidationChecks } from 'langium';
import type { K3AstType, Person } from './generated/ast.js';
import type { K3Services } from './k-3-module.js';

/**
 * Register custom validation checks.
 */
export function registerValidationChecks(services: K3Services) {
    const registry = services.validation.ValidationRegistry;
    const validator = services.validation.K3Validator;
    const checks: ValidationChecks<K3AstType> = {
        Person: validator.checkPersonStartsWithCapital
    };
    registry.register(checks, validator);
}

/**
 * Implementation of custom validations.
 */
export class K3Validator {

    checkPersonStartsWithCapital(person: Person, accept: ValidationAcceptor): void {
        if (person.name) {
            const firstChar = person.name.substring(0, 1);
            if (firstChar.toUpperCase() !== firstChar) {
                accept('warning', 'Person name should start with a capital.', { node: person, property: 'name' });
            }
        }
    }

}
