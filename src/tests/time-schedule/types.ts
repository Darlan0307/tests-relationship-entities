export type LessonPayload = {
  teacherId: number;
  classId: number;
  timeScheduleId?: number;
  disciplineId: string;
  weekDay: string; // Podemos trocar por um enum
  schedule: string;
};
