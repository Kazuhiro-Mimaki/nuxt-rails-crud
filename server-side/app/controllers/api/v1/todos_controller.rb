class Api::V1::TodosController < ApplicationController
  before_action :set_todo, only: [:update, :destroy]

  def index
    todos = Todo.all
    render json: { status: 'SUCCESS', message: 'Loaded todos', data: todos }
  end

  def create
    todo = Todo.new(todo_params)
    if todo.save
      render json: { status: 'SUCCESS', data: todo }
    else
      render json: { status: 'ERROR', data: todo.errors }
    end
  end

  def destroy
    @todo.destroy
    render json: { status: 'SUCCESS', message: 'Deleted the todo', data: @todo }
  end

  def update
    if @todo.update(todo_params)
      render json: { status: 'SUCCESS', message: 'Updated the todo', data: @todo }
    else
      render json: { status: 'ERROR', message: 'Not updated', data: @todo.errors }
    end
  end

  private

    def set_todo
      @todo = todo.find(params[:id])
    end

    def todo_params
      params.require(:todo).permit(:title, :isDone)
    end
end
