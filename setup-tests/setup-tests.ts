
import { prismaDB } from "src/shared/prisma";
import { afterAll, beforeAll } from "vitest";

beforeAll(async () => {
  await prismaDB.$connect();
  
});


afterAll(async () => {
  await prismaDB.$disconnect();
});
