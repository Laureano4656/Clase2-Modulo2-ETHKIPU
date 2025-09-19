// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

contract ToDoList {
    struct Task {
        string description;
        bool completed;
        uint256 timestamp;
    }
    Task[] public s_tasks; // Array de tareas en el storage

    event ToDoList_TaskCreated(Task task);
    event ToDoList_TaskCompleted(Task task);
    event ToDoList_TaskDeleted(string description, uint256 timestamp);

    function createTask(string memory _description) external {
        Task memory newTask = Task({
            description: _description,
            completed: false,
            timestamp: block.timestamp
        });
        s_tasks.push(newTask);
        emit ToDoList_TaskCreated(newTask);
    }
    function getTask(uint256 _index) external view returns (Task memory) {
        // no se le pone memory al index porque es un primitivo, se pasa por tipo valor
        return s_tasks[_index];
    }
    function completeTask(uint256 _index) external {
        s_tasks[_index].completed = true;
        emit ToDoList_TaskCompleted(s_tasks[_index]);
    }
    function deleteTask(string memory _description) external {
        uint256 arrayLength = s_tasks.length;
        for (uint256 i = 0; i < arrayLength - 1; i++) {
            if (
                keccak256(abi.encodePacked(s_tasks[i].description)) ==
                keccak256(abi.encodePacked(_description))
            ) {
                s_tasks[i] = s_tasks[arrayLength - 1]; // Reemplazar con el último elemento
                s_tasks.pop(); // Eliminar el último elemento duplicado
                emit ToDoList_TaskDeleted(_description, block.timestamp);
                return; // Salir del bucle una vez que se ha encontrado y reemplazado la tarea
            }
        }
    }
}
