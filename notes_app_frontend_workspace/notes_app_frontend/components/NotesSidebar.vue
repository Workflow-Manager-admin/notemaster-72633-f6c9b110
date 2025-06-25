<script setup lang="ts">
import { ref, computed, watch, toRefs } from "vue";

const props = defineProps<{
  notes: { id: string, title: string, updated: string }[],
  selectedId: string | null,
}>();
const emits = defineEmits<{
  (e: "select", id: string): void;
  (e: "new"): void;
}>();
function select(id: string) {
  emits("select", id);
}
function createNew() {
  emits("new");
}
</script>

<template>
  <aside class="notes-sidebar">
    <div class="sidebar-header">
      <span class="sidebar-title">Notes</span>
      <button class="new-btn" title="New note" @click="createNew">
        +
      </button>
    </div>
    <ul class="notes-list">
      <li v-for="note in notes"
          :key="note.id"
          :class="['notes-list-item', { active: note.id === selectedId }]"
          @click="select(note.id)">
        <div class="note-title">{{ note.title || 'Untitled' }}</div>
        <div class="note-updated">{{ new Date(note.updated).toLocaleDateString() }}</div>
      </li>
      <li v-if="notes.length === 0" class="notes-list-item empty">
        No notes yet.
      </li>
    </ul>
  </aside>
</template>

<style scoped>
.notes-sidebar {
  height: 100%;
  width: 260px;
  background: #fff;
  border-right: 1px solid #F3F4F6;
  display: flex;
  flex-direction: column;
  font-family: 'Inter', sans-serif;
}

.sidebar-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 1.5rem 1.2rem 1rem 1.2rem;
  border-bottom: 1px solid #ECECEC;
  background: #f9faff;
}
.sidebar-title {
  font-weight: 600;
  letter-spacing: 0.08em;
  color: #4F46E5;
  font-size: 1.3rem;
}
.new-btn {
  background: #EF4444;
  border: none;
  color: #fff;
  font-size: 1.4rem;
  min-width: 2rem;
  min-height: 2rem;
  border-radius: 6px;
  cursor: pointer;
  transition: background 0.2s;
}
.new-btn:hover {
  background: #d93030;
}

.notes-list {
  padding: 0.5em 0;
  list-style: none;
  margin: 0;
  flex: 1;
  overflow-y: auto;
}
.notes-list-item {
  padding: 0.8em 1.3em 0.7em 1.3em;
  border-left: 4px solid transparent;
  font-size: 1.02em;
  color: #1E293B;
  cursor: pointer;
  transition: background 0.18s, border-left 0.18s;
  display: flex;
  flex-direction: column;
  border-bottom: 1px solid #F3F4F6;
}
.notes-list-item:hover, .notes-list-item.active {
  background: #F1F5FF;
  border-left: 4px solid #4F46E5;
}
.note-title {
  font-size: 1em;
  font-weight: 500;
  overflow: hidden;
  text-overflow: ellipsis;
  margin-bottom: 1px;
}
.note-updated {
  font-size: 0.87em;
  color: #94A3B8;
}
.notes-list-item.empty {
  color: #AAA;
  padding-top: 2em;
  cursor: default;
}
</style>
