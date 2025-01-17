/*
  Warnings:

  - The primary key for the `disciplines` table will be changed. If it partially fails, the table could be left without primary key constraint.
  - You are about to drop the column `id` on the `disciplines` table. All the data in the column will be lost.
  - You are about to drop the column `name` on the `disciplines` table. All the data in the column will be lost.
  - Added the required column `discipline_id` to the `disciplines` table without a default value. This is not possible if the table is not empty.

*/
-- RedefineTables
PRAGMA defer_foreign_keys=ON;
PRAGMA foreign_keys=OFF;
CREATE TABLE "new_disciplines" (
    "discipline_id" TEXT NOT NULL PRIMARY KEY,
    "created_at" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" DATETIME NOT NULL,
    "deleted_at" DATETIME
);
INSERT INTO "new_disciplines" ("created_at", "deleted_at", "updated_at") SELECT "created_at", "deleted_at", "updated_at" FROM "disciplines";
DROP TABLE "disciplines";
ALTER TABLE "new_disciplines" RENAME TO "disciplines";
CREATE TABLE "new_disciplines_teachers" (
    "discipline_id" TEXT NOT NULL,
    "teacher_id" INTEGER NOT NULL,
    CONSTRAINT "disciplines_teachers_discipline_id_fkey" FOREIGN KEY ("discipline_id") REFERENCES "disciplines" ("discipline_id") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "disciplines_teachers_teacher_id_fkey" FOREIGN KEY ("teacher_id") REFERENCES "teachers" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);
INSERT INTO "new_disciplines_teachers" ("discipline_id", "teacher_id") SELECT "discipline_id", "teacher_id" FROM "disciplines_teachers";
DROP TABLE "disciplines_teachers";
ALTER TABLE "new_disciplines_teachers" RENAME TO "disciplines_teachers";
CREATE UNIQUE INDEX "disciplines_teachers_discipline_id_teacher_id_key" ON "disciplines_teachers"("discipline_id", "teacher_id");
CREATE TABLE "new_student_frequencies" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "student_id" INTEGER NOT NULL,
    "class_id" INTEGER NOT NULL,
    "discipline_id" TEXT NOT NULL,
    "teacher_id" INTEGER NOT NULL,
    "bimester" TEXT NOT NULL,
    "date" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "wasPresent" INTEGER NOT NULL DEFAULT 1,
    "created_at" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" DATETIME NOT NULL,
    "deleted_at" DATETIME,
    CONSTRAINT "student_frequencies_student_id_fkey" FOREIGN KEY ("student_id") REFERENCES "students" ("student_id") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "student_frequencies_class_id_fkey" FOREIGN KEY ("class_id") REFERENCES "classes" ("id") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "student_frequencies_discipline_id_fkey" FOREIGN KEY ("discipline_id") REFERENCES "disciplines" ("discipline_id") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "student_frequencies_teacher_id_fkey" FOREIGN KEY ("teacher_id") REFERENCES "teachers" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);
INSERT INTO "new_student_frequencies" ("bimester", "class_id", "created_at", "date", "deleted_at", "discipline_id", "id", "student_id", "teacher_id", "updated_at", "wasPresent") SELECT "bimester", "class_id", "created_at", "date", "deleted_at", "discipline_id", "id", "student_id", "teacher_id", "updated_at", "wasPresent" FROM "student_frequencies";
DROP TABLE "student_frequencies";
ALTER TABLE "new_student_frequencies" RENAME TO "student_frequencies";
CREATE TABLE "new_student_grades" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "student_id" INTEGER NOT NULL,
    "discipline_id" TEXT NOT NULL,
    "bimester" TEXT NOT NULL,
    "grade" REAL NOT NULL,
    "created_at" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" DATETIME NOT NULL,
    "deleted_at" DATETIME,
    CONSTRAINT "student_grades_student_id_fkey" FOREIGN KEY ("student_id") REFERENCES "students" ("student_id") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "student_grades_discipline_id_fkey" FOREIGN KEY ("discipline_id") REFERENCES "disciplines" ("discipline_id") ON DELETE RESTRICT ON UPDATE CASCADE
);
INSERT INTO "new_student_grades" ("bimester", "created_at", "deleted_at", "discipline_id", "grade", "id", "student_id", "updated_at") SELECT "bimester", "created_at", "deleted_at", "discipline_id", "grade", "id", "student_id", "updated_at" FROM "student_grades";
DROP TABLE "student_grades";
ALTER TABLE "new_student_grades" RENAME TO "student_grades";
PRAGMA foreign_keys=ON;
PRAGMA defer_foreign_keys=OFF;
