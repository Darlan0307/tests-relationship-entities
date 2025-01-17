/*
  Warnings:

  - You are about to drop the column `discipline_name` on the `student_grades` table. All the data in the column will be lost.
  - Added the required column `discipline_id` to the `student_grades` table without a default value. This is not possible if the table is not empty.

*/
-- CreateTable
CREATE TABLE "student_frequencies" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "student_id" INTEGER NOT NULL,
    "class_id" INTEGER NOT NULL,
    "discipline_id" INTEGER NOT NULL,
    "teacher_id" INTEGER NOT NULL,
    "bimester" TEXT NOT NULL,
    "time" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "wasPresent" BOOLEAN NOT NULL DEFAULT true,
    "year" INTEGER NOT NULL,
    "created_at" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" DATETIME NOT NULL,
    "deleted_at" DATETIME,
    CONSTRAINT "student_frequencies_student_id_fkey" FOREIGN KEY ("student_id") REFERENCES "students" ("student_id") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "student_frequencies_class_id_fkey" FOREIGN KEY ("class_id") REFERENCES "classes" ("id") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "student_frequencies_discipline_id_fkey" FOREIGN KEY ("discipline_id") REFERENCES "disciplines" ("id") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "student_frequencies_teacher_id_fkey" FOREIGN KEY ("teacher_id") REFERENCES "teachers" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);

-- RedefineTables
PRAGMA defer_foreign_keys=ON;
PRAGMA foreign_keys=OFF;
CREATE TABLE "new_student_grades" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "student_id" INTEGER NOT NULL,
    "discipline_id" INTEGER NOT NULL,
    "bimester" TEXT NOT NULL,
    "grade" REAL NOT NULL,
    "created_at" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" DATETIME NOT NULL,
    "deleted_at" DATETIME,
    CONSTRAINT "student_grades_student_id_fkey" FOREIGN KEY ("student_id") REFERENCES "students" ("student_id") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "student_grades_discipline_id_fkey" FOREIGN KEY ("discipline_id") REFERENCES "disciplines" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);
INSERT INTO "new_student_grades" ("bimester", "created_at", "deleted_at", "grade", "id", "student_id", "updated_at") SELECT "bimester", "created_at", "deleted_at", "grade", "id", "student_id", "updated_at" FROM "student_grades";
DROP TABLE "student_grades";
ALTER TABLE "new_student_grades" RENAME TO "student_grades";
PRAGMA foreign_keys=ON;
PRAGMA defer_foreign_keys=OFF;
