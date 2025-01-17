import { prismaDB } from "src/shared/prisma";
import { describe, it, expect, afterEach } from "vitest";
import { StudentPayload } from "./types";
import { newCpf, newEmail } from "src/shared/tests";
import { DisciplineName } from "../disciplines";

describe("Alunos", () => {
  afterEach(async () => {
    await prismaDB.studentGrade.deleteMany();
    await prismaDB.studentFrequency.deleteMany();
    await prismaDB.student.deleteMany();
    await prismaDB.teacher.deleteMany();
    await prismaDB.class.deleteMany();
  });

  const createStudent = async (payload: StudentPayload) => {
    const student = await prismaDB.student.create({
      data: payload,
    });
    return student;
  };

  it("Deve criar um aluno", async () => {
    const payload = {
      name: "João",
      cpf: newCpf(),
      email: newEmail(),
    };
    const student = await createStudent(payload);

    expect(student).toMatchObject(payload);
  });

  it("Deve listar todos os alunos", async () => {
    await createStudent({
      name: "Darlan",
      cpf: newCpf(),
    });
    await createStudent({
      name: "Maria",
      cpf: newCpf(),
    });
    await createStudent({
      name: "João",
      cpf: newCpf(),
    });

    const students = await prismaDB.student.findMany();

    expect(students).toHaveLength(3);
  });

  it("Deve listar todas as notas de um aluno", async () => {
    const newClass = await prismaDB.class.create({
      data: {
        name: "Nome da turma 1",
      },
    });

    const student = await createStudent({
      name: "Darlan Martins",
      cpf: newCpf(),
    });

    await prismaDB.studentGrade.create({
      data: {
        studentId: student.id,
        disciplineId: DisciplineName.MATEMATICA,
        bimester: "1º bimestre",
        grade: 10.0,
        classId: newClass.id,
      },
    });

    await prismaDB.studentGrade.create({
      data: {
        studentId: student.id,
        disciplineId: DisciplineName.FISICA,
        bimester: "1º bimestre",
        grade: 7.5,
        classId: newClass.id,
      },
    });

    await prismaDB.studentGrade.create({
      data: {
        studentId: student.id,
        disciplineId: DisciplineName.INGLES,
        bimester: "1º bimestre",
        grade: 6,
        classId: newClass.id,
      },
    });

    // const student = await prismaDB.student.findUnique({
    //   where: {
    //     id: student.id,
    //   },
    //   include: {
    //     studentGrades: true,
    //   },
    // });

    const studentGrades = await prismaDB.studentGrade.findMany({
      where: {
        studentId: student.id,
        classId: newClass.id,
      },
    });

    expect(studentGrades).toHaveLength(3);
    expect(studentGrades).toMatchObject([
      {
        studentId: student.id,
        disciplineId: DisciplineName.MATEMATICA,
        bimester: "1º bimestre",
        grade: 10.0,
      },
      {
        studentId: student.id,
        disciplineId: DisciplineName.FISICA,
        bimester: "1º bimestre",
        grade: 7.5,
      },
      {
        studentId: student.id,
        disciplineId: DisciplineName.INGLES,
        bimester: "1º bimestre",
        grade: 6,
      },
    ]);
  });

  it("Devo buscar a turma de um aluno", async () => {
    const newClass = await prismaDB.class.create({
      data: {
        name: "Nome da turma 1",
      },
    });

    const student = await createStudent({
      name: "Darlan Martins",
      cpf: newCpf(),
      classId: newClass.id,
    });

    const result = await prismaDB.student.findUnique({
      where: {
        id: student.id,
      },
      include: {
        class: true,
      },
    });

    expect(result).toMatchObject({
      class: {
        id: newClass.id,
        name: "Nome da turma 1",
      },
    });
  });

  it("Devo consultar a frequência de um aluno", async () => {
    const date = new Date();

    const newClass = await prismaDB.class.create({
      data: {
        name: "turma 1",
      },
    });

    const student = await createStudent({
      name: "Darlan Martins",
      cpf: newCpf(),
      classId: newClass.id,
    });

    const teacher = await prismaDB.teacher.create({
      data: {
        name: "Darlan Martins",
      },
    });

    await prismaDB.studentFrequency.create({
      data: {
        studentId: student.id,
        classId: newClass.id,
        disciplineId: DisciplineName.BIOLOGIA,
        teacherId: teacher.id,
        bimester: "1º bimestre",
        date,
      },
    });
    await prismaDB.studentFrequency.create({
      data: {
        studentId: student.id,
        classId: newClass.id,
        disciplineId: DisciplineName.BIOLOGIA,
        teacherId: teacher.id,
        bimester: "1º bimestre",
        wasPresent: 0,
        date,
      },
    });
    await prismaDB.studentFrequency.create({
      data: {
        studentId: student.id,
        classId: newClass.id,
        disciplineId: DisciplineName.FISICA,
        teacherId: teacher.id,
        bimester: "1º bimestre",
        wasPresent: 0,
        date,
      },
    });
    await prismaDB.studentFrequency.create({
      data: {
        studentId: student.id,
        classId: newClass.id,
        disciplineId: DisciplineName.GEOGRAFIA,
        teacherId: teacher.id,
        bimester: "1º bimestre",
        wasPresent: 0,
        date,
      },
    });

    await prismaDB.studentFrequency.create({
      data: {
        studentId: student.id,
        classId: newClass.id,
        disciplineId: DisciplineName.PORTUGUES,
        teacherId: teacher.id,
        bimester: "1º bimestre",
        date: new Date(`2000-01-01`),
      },
    });

    await prismaDB.studentFrequency.create({
      data: {
        studentId: student.id,
        classId: newClass.id,
        disciplineId: DisciplineName.PORTUGUES,
        teacherId: teacher.id,
        bimester: "1º bimestre",
        date: new Date(`2000-01-01`),
      },
    });

    const allFrequenciesGroupedByDiscipline =
      await prismaDB.studentFrequency.groupBy({
        by: ["disciplineId"],
        where: {
          studentId: student.id,
          classId: newClass.id,
          // para simplificar esse filtro podemos criar um campo somente para o ano
          date: {
            gte: new Date(`${date.getFullYear()}-01-01`),
            lt: new Date(`${date.getFullYear() + 1}-01-01`),
          },
        },
        _count: {
          _all: true,
        },
        _sum: {
          wasPresent: true,
        },
        _avg: {
          wasPresent: true,
        },
      });
    console.log(allFrequenciesGroupedByDiscipline);

    expect(allFrequenciesGroupedByDiscipline).toMatchObject([
      {
        _count: { _all: 2 },
        _sum: { wasPresent: 1 },
        _avg: { wasPresent: 0.5 },
        disciplineId: DisciplineName.BIOLOGIA,
      },
      {
        _count: { _all: 1 },
        _sum: { wasPresent: 0 },
        _avg: { wasPresent: 0 },
        disciplineId: DisciplineName.FISICA,
      },
      {
        _count: { _all: 1 },
        _sum: { wasPresent: 0 },
        _avg: { wasPresent: 0 },
        disciplineId: DisciplineName.GEOGRAFIA,
      },
    ]);
  });
});
