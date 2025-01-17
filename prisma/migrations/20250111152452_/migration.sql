/*
  Warnings:

  - You are about to drop the column `discipline_id` on the `student_grades` table. All the data in the column will be lost.
  - A unique constraint covering the columns `[name]` on the table `disciplines` will be added. If there are existing duplicate values, this will fail.
  - Added the required column `discipline_name` to the `student_grades` table without a default value. This is not possible if the table is not empty.

*/
-- RedefineTables
PRAGMA defer_foreign_keys=ON;
PRAGMA foreign_keys=OFF;
CREATE TABLE "new_student_grades" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "student_id" INTEGER NOT NULL,
    "discipline_name" TEXT NOT NULL,
    "bimester" TEXT NOT NULL,
    "grade" REAL NOT NULL,
    "created_at" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" DATETIME NOT NULL,
    "deleted_at" DATETIME,
    CONSTRAINT "student_grades_student_id_fkey" FOREIGN KEY ("student_id") REFERENCES "students" ("student_id") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "student_grades_discipline_name_fkey" FOREIGN KEY ("discipline_name") REFERENCES "disciplines" ("name") ON DELETE RESTRICT ON UPDATE CASCADE
);
INSERT INTO "new_student_grades" ("bimester", "created_at", "deleted_at", "grade", "id", "student_id", "updated_at") SELECT "bimester", "created_at", "deleted_at", "grade", "id", "student_id", "updated_at" FROM "student_grades";
DROP TABLE "student_grades";
ALTER TABLE "new_student_grades" RENAME TO "student_grades";
PRAGMA foreign_keys=ON;
PRAGMA defer_foreign_keys=OFF;

-- CreateIndex
CREATE UNIQUE INDEX "disciplines_name_key" ON "disciplines"("name");
