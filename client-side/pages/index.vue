<script lang="ts">
import {
  defineComponent,
  reactive,
  ref,
  onMounted,
} from "@nuxtjs/composition-api";
import { ITodo } from "../models/todo";
import $axios from "@nuxtjs/axios";

export default defineComponent({
  setup(_, { root }) {
    onMounted(() => {
      getTodo();
    });

    const todoItem = reactive({
      title: "",
      isDone: false,
    });

    const todoList = ref<ITodo[]>([]);
    const completeTodoList = ref<ITodo[]>([]);

    // todoをpost
    const addTodo = async () => {
      try {
        await root.$axios.post("/api/todos/", {
          title: todoItem.title,
          isDone: todoItem.isDone,
        });
        getTodo();
        todoItem.title = "";
      } catch (e) {
        console.log(e);
      }
    };

    // todoをget
    const getTodo = async () => {
      try {
        const response = await root.$axios.get("/api/todos");
        todoList.value = { ...response.data.data };
        getCompleteTodo();
      } catch (e) {
        console.log(e);
      }
    };

    // todoをupdate
    const updateTodo = async (i: number, todo: ITodo) => {
      try {
        const newTodo = todoList.value[i].title;
        await root.$axios.patch(`/api/todos/${todo.id}`, { title: newTodo });
      } catch (e) {
        console.log(e);
      }
    };

    // todoをdelete
    const deleteTodo = async (id: number) => {
      try {
        await root.$axios.delete(`/api/todos/${id}`);
        getTodo();
      } catch (e) {
        console.log(e);
      }
    };

    // todoをdone
    const completeTodo = async (todo: ITodo) => {
      try {
        todo.isDone = !todo.isDone;
        await root.$axios.patch(`/api/todos/${todo.id}`, {
          isDone: todo.isDone,
        });
        getTodo();
      } catch (e) {
        console.log(e);
      }
    };

    // complete_todoをget
    const getCompleteTodo = async () => {
      try {
        const response = await root.$axios.get("/api/todos/complete");
        completeTodoList.value = { ...response.data.data };
      } catch (e) {
        console.log(e);
      }
    };

    return {
      todoItem,
      todoList,
      completeTodoList,
      addTodo,
      deleteTodo,
      updateTodo,
      completeTodo,
    };
  },
});
</script>

<template>
  <div class="container">
    <section class="todo-new">
      <h1>Add todos</h1>
      <input v-model="todoItem.title" type="text" placeholder="todoを記入" />
      <button @click="addTodo()">Todoを追加</button>
    </section>

    <section class="todo-index">
      <h1>Incomplete todos</h1>
      <ul>
        <li v-for="(todo, i) in todoList" :key="i">
          <input
            class="item"
            type="checkbox"
            :checked="todo.isDone"
            @change="completeTodo(todo)"
          />
          <input
            class="item"
            type="text"
            v-model="todo.title"
            @change="updateTodo(i, todo)"
          />
          <button @click="deleteTodo(todo.id)">削除する</button>
        </li>
      </ul>
    </section>

    <section class="todo-complete">
      <h1>Complete todos</h1>
      <ul>
        <li v-for="(todo, i) in completeTodoList" :key="i">
          <input
            class="item"
            type="checkbox"
            :checked="todo.isDone"
            @change="completeTodo(todo)"
          />
          {{ todo.title }}
          <button @click="deleteTodo(todo.id)">削除する</button>
        </li>
      </ul>
    </section>
  </div>
</template>

<style>
.container {
  margin: 80px auto;
  min-height: 100vh;
  text-align: center;
}

section {
  margin-bottom: 30px;
}

.item {
  font-size: 1rem;
  margin: 0 10x;
}

li {
  list-style: none;
  margin-bottom: 0.5em;
}
</style>
