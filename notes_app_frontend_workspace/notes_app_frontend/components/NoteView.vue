<script setup lang="ts">
const props = defineProps<{
  note: { id?: string, title: string, content: string, updated?: string } | null,
}>();
const emits = defineEmits<{
  (e: "edit", note: any): void;
}>();
function edit() {
  if (props.note) emits("edit", props.note);
}
</script>

<template>
  <div v-if="note" class="note-view">
    <div class="view-header">
      <div class="view-title">
        {{ note.title || 'Untitled' }}
      </div>
      <button class="edit-btn" @click="edit">
        Edit
      </button>
    </div>
    <div class="view-content">
      <pre v-if="note.content" class="note-content">{{ note.content }}</pre>
      <div v-else class="note-empty">No content.</div>
    </div>
    <div class="view-updated">
      {{ note.updated ? "Last edited: " + (new Date(note.updated)).toLocaleString() : "" }}
    </div>
  </div>
  <div v-else class="note-empty">
    <p><i>No note selected.</i></p>
  </div>
</template>

<style scoped>
.note-view {
  display: flex;
  flex-direction: column;
  height: 100%;
  padding: 2.1em 2em 1.1em 2em;
  font-family: 'Inter', sans-serif;
}
.view-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 1.5em;
}
.view-title {
  font-size: 1.4em;
  font-weight: 600;
  color: #4F46E5;
  margin-right: 1em;
}
.edit-btn {
  background: #F59E42;
  color: #fff;
  border: none;
  padding: 0.47em 1.3em;
  font-weight: 600;
  font-size: 1em;
  border-radius: 6px;
  cursor: pointer;
  transition: background 0.18s;
}
.edit-btn:hover { background: #ed9700; }
.view-content {
  flex: 1;
  font-size: 1.07em;
  color: #203550;
  margin-bottom: 1.5em;
  white-space: pre-wrap;
}
.note-content {
  font-family: inherit;
  background: #F9FAFB;
  padding: 1em 1em;
  border-radius: 8px;
  margin: 0;
}
.view-updated {
  font-size: 0.95em;
  color: #8A8BBC;
  margin-top: 0.6em;
  text-align: right;
}
.note-empty {
  display: flex;
  align-items: center; justify-content: center;
  height: 100%;
  min-height: 230px;
  color: #bcbcbc;
  font-size: 1.2rem;
}
</style>
