import { PrismaClient } from "@prisma/client";
import { DisciplineName } from "src/tests/disciplines";

const prisma = new PrismaClient();

async function main() {
  const disciplines = [
    { id: DisciplineName.MATEMATICA },
    { id: DisciplineName.FISICA },
    { id: DisciplineName.QUIMICA },
    { id: DisciplineName.BIOLOGIA },
    { id: DisciplineName.HISTORIA },
    { id: DisciplineName.GEOGRAFIA },
    { id: DisciplineName.PORTUGUES },
    { id: DisciplineName.INGLES },
  ];

  for (const discipline of disciplines) {
    await prisma.discipline.create({
      data: discipline,
    });
  }

  console.log("Disciplinas criadas com sucesso!");
}

main()
  .catch((e) => {
    console.error(e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
