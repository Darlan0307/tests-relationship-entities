/*
  Warnings:

  - You are about to drop the column `time` on the `student_frequencies` table. All the data in the column will be lost.
  - You are about to drop the column `year` on the `student_frequencies` table. All the data in the column will be lost.

*/
-- RedefineTables
PRAGMA defer_foreign_keys=ON;
PRAGMA foreign_keys=OFF;
CREATE TABLE "new_student_frequencies" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "student_id" INTEGER NOT NULL,
    "class_id" INTEGER NOT NULL,
    "discipline_id" INTEGER NOT NULL,
    "teacher_id" INTEGER NOT NULL,
    "bimester" TEXT NOT NULL,
    "date" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "wasPresent" BOOLEAN NOT NULL DEFAULT true,
    "created_at" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" DATETIME NOT NULL,
    "deleted_at" DATETIME,
    CONSTRAINT "student_frequencies_student_id_fkey" FOREIGN KEY ("student_id") REFERENCES "students" ("student_id") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "student_frequencies_class_id_fkey" FOREIGN KEY ("class_id") REFERENCES "classes" ("id") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "student_frequencies_discipline_id_fkey" FOREIGN KEY ("discipline_id") REFERENCES "disciplines" ("id") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "student_frequencies_teacher_id_fkey" FOREIGN KEY ("teacher_id") REFERENCES "teachers" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);
INSERT INTO "new_student_frequencies" ("bimester", "class_id", "created_at", "deleted_at", "discipline_id", "id", "student_id", "teacher_id", "updated_at", "wasPresent") SELECT "bimester", "class_id", "created_at", "deleted_at", "discipline_id", "id", "student_id", "teacher_id", "updated_at", "wasPresent" FROM "student_frequencies";
DROP TABLE "student_frequencies";
ALTER TABLE "new_student_frequencies" RENAME TO "student_frequencies";
PRAGMA foreign_keys=ON;
PRAGMA defer_foreign_keys=OFF;
