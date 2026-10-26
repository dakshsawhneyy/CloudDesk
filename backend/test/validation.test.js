const test = require("node:test");
const assert = require("node:assert/strict");

const {
  validateTaskTitle,
  validateTaskStatus,
} = require("../src/validation");

test("accepts a valid task title", () => {
  assert.equal(validateTaskTitle("Learn Docker"), true);
});

test("rejects an empty task title", () => {
  assert.equal(validateTaskTitle("   "), false);
});

test("rejects a title longer than 200 characters", () => {
  assert.equal(validateTaskTitle("a".repeat(201)), false);
});

test("accepts supported task statuses", () => {
  assert.equal(validateTaskStatus("pending"), true);
  assert.equal(validateTaskStatus("completed"), true);
});

test("rejects unsupported task statuses", () => {
  assert.equal(validateTaskStatus("in-progress"), false);
});