const express = require("express");
const app = express();
const port = process.env.PORT || 8000;
const toDoList = [];

app.use(express.json()); // Parse JSON bodies

app.get("/", (req, res) => {
  res.set("Content-Type", "text/html");
  res.send("Hello world !!");
});

app.get("/todo", (req, res) => {
  res.set("Content-Type", "application/json");
  res.send(toDoList);
});

app.post("/todo", (req, res) => {
  console.log(req.body);
  let item = req.body.item;
  toDoList.push({ item: item, isCompleted: false });
  res.set("Content-Type", "application/json");
  res.send(toDoList);
});

app.delete("/todo/:index", (req, res) => {
  const index = req.params.index;
  toDoList.splice(index, 1);
  res.set("Content-Type", "application/json");
  console.log(toDoList);
  res.send(toDoList);
});

app.put("/todo/:index", (req, res) => {
  const index = req.params.index;
  
  let item = toDoList[index];
  item.isCompleted = !item.isCompleted;
  toDoList[index] = item;
  console.log(toDoList);
  res.set("Content-Type", "application/json");
  res.send(toDoList);
});

app.listen(port, () => {
  console.log("Server app listening on port " + port);
});
