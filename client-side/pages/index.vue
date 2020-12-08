<script lang="ts">
import {
  defineComponent,
  reactive,
  ref,
  onMounted,
} from '@nuxtjs/composition-api';
import { ITodo } from '../models/todo';
import $axios from '@nuxtjs/axios';

export default defineComponent({
  setup(_, { root }) {
    onMounted(() => {
      getTodo();
    });

    const todoItem = reactive({
      title: '',
      isDone: false,
    });

    const todoList = ref<ITodo[]>([]);

    // todoをpost
    const addTodo = async () => {
      try {
        await root.$axios.post('/api/todos/', {
          title: todoItem.title,
          isDone: todoItem.isDone,
        });
        getTodo();
        todoItem.title = '';
      } catch (e) {
        console.log(e);
      }
    };

    // todoをget
    const getTodo = async () => {
      try {
        const response = await root.$axios.get('/api/todos');
        todoList.value = { ...response.data.data };
      } catch (e) {
        console.log(e);
      }
    };

    // todoをupdate
    const updateTodo = async (i: number, id: number) => {
      try {
        const newTodo = todoList.value[i].title;
        await root.$axios.patch(`/api/todos/${id}`, { title: newTodo });
        getTodo();
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

    return { todoItem, todoList, addTodo, deleteTodo, updateTodo };
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
      <Logo />
      <ul>
        <li v-for="(todo, i) in todoList" :key="i">
          <input
            type="text"
            v-model="todo.title"
            @change="updateTodo(i, todo.id)"
          />
          {{ todo.title }}
          <button @click="deleteTodo(todo.id)">削除する</button>
        </li>
      </ul>
    </div>
  </div>
</template>

<style>
.container {
  margin: 0 auto;
  min-height: 100vh;
  display: flex;
  justify-content: center;
  align-items: center;
  text-align: center;
}

.title {
  font-family: 'Quicksand', 'Source Sans Pro', -apple-system, BlinkMacSystemFont,
    'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
  display: block;
  font-weight: 300;
  font-size: 100px;
  color: #35495e;
  letter-spacing: 1px;
}

.subtitle {
  font-weight: 300;
  font-size: 42px;
  color: #526488;
  word-spacing: 5px;
  padding-bottom: 15px;
}

.links {
  padding-top: 15px;
}
</style>
