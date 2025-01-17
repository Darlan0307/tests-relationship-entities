import { fake } from 'validation-br/dist/cpf'
import { faker } from '@faker-js/faker';

export const newCpf = (hasMask = false) => fake(hasMask)

export const newEmail = () => faker.internet.email()