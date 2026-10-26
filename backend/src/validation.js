function validateTaskTitle(title) {
  return (
    typeof title === "string" &&
    title.trim().length > 0 &&
    title.trim().length <= 200
  );
}

function validateTaskStatus(status) {
  return ["pending", "completed"].includes(status);
}

module.exports = {
  validateTaskTitle,
  validateTaskStatus,
};