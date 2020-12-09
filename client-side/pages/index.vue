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
    <div>
      <input
        v-model="todoItem.title"
        type="text"
        placeholder="ここにタスク内容が入ります"
      />
      <button @click="addTodo()">Todoを追加</button>
    </div>
    <ul>
      <li v-for="(todo, i) in todoList" :key="i">
        <input
          type="checkbox"
          :checked="todo.isDone"
          @change="completeTodo(todo)"
        />
        <input type="text" v-model="todo.title" @change="updateTodo(i, todo)" />
        <button @click="deleteTodo(todo.id)">削除する</button>
      </li>
    </ul>

    <div>
      <h2>Complete todos</h2>
      <ul>
        <li v-for="(todo, i) in completeTodoList" :key="i">
          {{ todo.title }}
        </li>
      </ul>
    </div>
  </div>
</template>

<style>
.container {
  margin: 0 auto;
  min-height: 100vh;
  text-align: center;
}
</style>
