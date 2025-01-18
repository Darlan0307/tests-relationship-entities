/*
  Warnings:

  - You are about to drop the `classes_teachers` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `disciplines_teachers` table. If the table is not empty, all the data it contains will be lost.

*/
-- DropTable
PRAGMA foreign_keys=off;
DROP TABLE "classes_teachers";
PRAGMA foreign_keys=on;

-- DropTable
PRAGMA foreign_keys=off;
DROP TABLE "disciplines_teachers";
PRAGMA foreign_keys=on;

-- CreateTable
CREATE TABLE "times_schedules" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "teacher_id" INTEGER NOT NULL,
    "class_id" INTEGER NOT NULL,
    "discipline_id" TEXT NOT NULL,
    "week_day" TEXT NOT NULL,
    "schedule" TEXT NOT NULL,
    "created_at" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" DATETIME NOT NULL,
    "deleted_at" DATETIME,
    CONSTRAINT "times_schedules_teacher_id_fkey" FOREIGN KEY ("teacher_id") REFERENCES "teachers" ("id") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "times_schedules_class_id_fkey" FOREIGN KEY ("class_id") REFERENCES "classes" ("id") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "times_schedules_discipline_id_fkey" FOREIGN KEY ("discipline_id") REFERENCES "disciplines" ("discipline_id") ON DELETE RESTRICT ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "teachers_classes_disciplines" (
    "teacher_id" INTEGER NOT NULL,
    "class_id" INTEGER NOT NULL,
    "discipline_id" TEXT NOT NULL,
    "created_at" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" DATETIME NOT NULL,
    "deleted_at" DATETIME,
    CONSTRAINT "teachers_classes_disciplines_teacher_id_fkey" FOREIGN KEY ("teacher_id") REFERENCES "teachers" ("id") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "teachers_classes_disciplines_class_id_fkey" FOREIGN KEY ("class_id") REFERENCES "classes" ("id") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "teachers_classes_disciplines_discipline_id_fkey" FOREIGN KEY ("discipline_id") REFERENCES "disciplines" ("discipline_id") ON DELETE RESTRICT ON UPDATE CASCADE
);

-- CreateIndex
CREATE UNIQUE INDEX "teachers_classes_disciplines_teacher_id_class_id_discipline_id_key" ON "teachers_classes_disciplines"("teacher_id", "class_id", "discipline_id");
