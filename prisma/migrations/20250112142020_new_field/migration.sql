/*
  Warnings:

  - Added the required column `classId` to the `student_grades` table without a default value. This is not possible if the table is not empty.

*/
-- RedefineTables
PRAGMA defer_foreign_keys=ON;
PRAGMA foreign_keys=OFF;
CREATE TABLE "new_student_grades" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "student_id" INTEGER NOT NULL,
    "discipline_id" TEXT NOT NULL,
    "bimester" TEXT NOT NULL,
    "classId" INTEGER NOT NULL,
    "grade" REAL NOT NULL,
    "created_at" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" DATETIME NOT NULL,
    "deleted_at" DATETIME,
    CONSTRAINT "student_grades_student_id_fkey" FOREIGN KEY ("student_id") REFERENCES "students" ("student_id") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "student_grades_discipline_id_fkey" FOREIGN KEY ("discipline_id") REFERENCES "disciplines" ("discipline_id") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "student_grades_classId_fkey" FOREIGN KEY ("classId") REFERENCES "classes" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);
INSERT INTO "new_student_grades" ("bimester", "created_at", "deleted_at", "discipline_id", "grade", "id", "student_id", "updated_at") SELECT "bimester", "created_at", "deleted_at", "discipline_id", "grade", "id", "student_id", "updated_at" FROM "student_grades";
DROP TABLE "student_grades";
ALTER TABLE "new_student_grades" RENAME TO "student_grades";
PRAGMA foreign_keys=ON;
PRAGMA defer_foreign_keys=OFF;
