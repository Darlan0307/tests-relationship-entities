import { prismaDB } from "src/shared/prisma";
import { afterEach, beforeAll, describe, expect, it } from "vitest";
import { LessonPayload } from "./types";
import { DisciplineName } from "../disciplines";
import { Class, Teacher } from "@prisma/client";

describe("Quadro de horários", () => {
  let teacher1: Teacher;
  let teacher2: Teacher;
  let class1: Class;

  beforeAll(async () => {
    teacher1 = await prismaDB.teacher.create({
      data: {
        name: "Darlan Martins",
      },
    });
    teacher2 = await prismaDB.teacher.create({
      data: {
        name: "João Silva",
      },
    });
    class1 = await prismaDB.class.create({
      data: {
        name: "Turma 1",
      },
    });
  });

  afterEach(async () => {
    await prismaDB.teacherClassDiscipline.deleteMany();
    await prismaDB.lesson.deleteMany();
    await prismaDB.timeSchedule.deleteMany();
    await prismaDB.teacher.deleteMany();
    await prismaDB.class.deleteMany();
  });

  const createTCDs = async (lessons: LessonPayload[]) => {
    for (let lesson of lessons) {
      const TCDExists = await prismaDB.teacherClassDiscipline.findUnique({
        where: {
          teacherId_classId_disciplineId: {
            teacherId: lesson.teacherId,
            classId: lesson.classId,
            disciplineId: lesson.disciplineId,
          },
        },
      });

      if (TCDExists) {
        continue;
      }

      await prismaDB.teacherClassDiscipline.create({
        data: {
          teacherId: lesson.teacherId,
          classId: lesson.classId,
          disciplineId: lesson.disciplineId,
        },
      });
    }
  };

  it("Deve criar um quadro de horários com 2 aulas definidas", async () => {
    // Array recebido como parâmetro
    const lessons = [
      {
        teacherId: teacher1.id,
        classId: class1.id,
        disciplineId: DisciplineName.MATEMATICA,
        weekDay: "SEGUNDA-FEIRA",
        schedule: "8:00",
      },
      {
        teacherId: teacher2.id,
        classId: class1.id,
        disciplineId: DisciplineName.BIOLOGIA,
        weekDay: "SEGUNDA-FEIRA",
        schedule: "8:50",
      },
    ];

    const timeSchedule = await prismaDB.timeSchedule.create({
      data: {
        description: "Horários de aula",
        lessons: {
          create: lessons,
        },
      },
    });

    const timeScheduleWithLessons = await prismaDB.timeSchedule.findUnique({
      where: {
        id: timeSchedule.id,
      },
      include: {
        lessons: {
          include: {
            teacher: true,
            class: true,
          },
        },
      },
    });

    // Cria automaticamente
    await createTCDs(lessons);

    const allTCDs = await prismaDB.teacherClassDiscipline.findMany();

    expect(allTCDs.length).toBe(2);
    expect(timeScheduleWithLessons?.lessons?.length).toBe(2);
    expect(timeScheduleWithLessons?.lessons).toMatchObject(lessons);
  });

  it("Deve editar um quadro de horários modificando uma aula e adicionando uma nova aula", async () => {
    const timeSchedule = await prismaDB.timeSchedule.create({
      data: {
        description: "Horários de aula",
        lessons: {
          create: [
            {
              teacherId: teacher1.id,
              classId: class1.id,
              disciplineId: DisciplineName.MATEMATICA,
              weekDay: "SEGUNDA-FEIRA",
              schedule: "8:00",
            },
          ],
        },
      },
      include: {
        lessons: {
          include: {
            teacher: true,
            class: true,
          },
        },
      },
    });
    console.log("Antes das atualizações");
    console.log(timeSchedule);
    expect(timeSchedule.lessons.length).toBe(1);
    expect(timeSchedule.lessons[0]).toMatchObject({
      teacherId: teacher1.id,
      classId: class1.id,
      disciplineId: DisciplineName.MATEMATICA,
      weekDay: "SEGUNDA-FEIRA",
      schedule: "8:00",
    });

    // Array recebido como parâmetro
    const lessonUpdates = [
      {
        id: timeSchedule.lessons[0].id,
        teacherId: teacher1.id,
        classId: class1.id,
        disciplineId: DisciplineName.QUIMICA,
        weekDay: "SEGUNDA-FEIRA",
        schedule: "8:00",
      },
      {
        teacherId: teacher2.id,
        classId: class1.id,
        disciplineId: DisciplineName.BIOLOGIA,
        weekDay: "SEGUNDA-FEIRA",
        schedule: "8:50",
      },
    ];

    const transactionOperations = lessonUpdates.map((lesson) =>
      lesson.id
        ? prismaDB.lesson.update({
            where: { id: lesson.id },
            data: lesson,
          })
        : prismaDB.lesson.create({
            data: {
              ...lesson,
              timeScheduleId: timeSchedule.id, // Id do quadro de horários que vem do parâmetro da rota
            },
          })
    );

    await prismaDB.$transaction(transactionOperations); // Para garantir a integridade dos dados
    await createTCDs(lessonUpdates);
    const updatedTimeSchedule = await prismaDB.timeSchedule.findUnique({
      where: {
        id: timeSchedule.id,
      },
      include: {
        lessons: {
          include: {
            teacher: true,
          },
        },
      },
    });

    const allTCDs = await prismaDB.teacherClassDiscipline.findMany();

    console.log("Depois das atualizações");
    console.log(updatedTimeSchedule);
    expect(allTCDs.length).toBe(2);
    expect(updatedTimeSchedule?.lessons?.length).toBe(2);
    expect(updatedTimeSchedule?.lessons).toMatchObject([
      {
        teacherId: teacher1.id,
        classId: class1.id,
        disciplineId: DisciplineName.QUIMICA,
        weekDay: "SEGUNDA-FEIRA",
        schedule: "8:00",
      },
      {
        teacherId: teacher2.id,
        classId: class1.id,
        disciplineId: DisciplineName.BIOLOGIA,
        weekDay: "SEGUNDA-FEIRA",
        schedule: "8:50",
      },
    ]);
  });
});
