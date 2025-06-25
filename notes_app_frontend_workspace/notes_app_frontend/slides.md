---
theme: default
layout: none
class: notes-app-root
---

<!-- PUBLIC_INTERFACE
Main Notes App - Single page with sidebar and main area,
CRUD notes functionality with clean modern minimal style.
-->

<script setup lang="ts">
import { ref, computed, reactive, onMounted, watch } from "vue";
import NotesSidebar from './components/NotesSidebar.vue';
import NoteEditor from './components/NoteEditor.vue';
import NoteView from './components/NoteView.vue';

type Note = {
  id: string,
  title: string,
  content: string,
  updated: string
};
const STORAGE_KEY = "slidev-notesapp-data";

const notes = ref<Note[]>([]);
const selectedId = ref<string|null>(null);
const mainMode = ref<"view"|"edit"|"new">("view");
const tempNote = ref<Note|null>(null);

// PUBLIC_INTERFACE
function saveNotesLocal() {
  localStorage.setItem(STORAGE_KEY, JSON.stringify(notes.value));
}
function loadNotesLocal() {
  const raw = localStorage.getItem(STORAGE_KEY);
  if (raw) {
    const arr: Note[] = JSON.parse(raw);
    notes.value = Array.isArray(arr) ? arr : [];
  } else {
    notes.value = [];
  }
}
onMounted(() => {
  loadNotesLocal();
  if (notes.value.length > 0)
    selectedId.value = notes.value[0].id;
});

watch(notes, saveNotesLocal, { deep: true });

const selectedNote = computed(() =>
  notes.value.find(n => n.id === selectedId.value) || null
);

// PUBLIC_INTERFACE
function onSelectNote(id: string) {
  selectedId.value = id;
  mainMode.value = "view";
}

// PUBLIC_INTERFACE
function onNewNote() {
  mainMode.value = "new";
  tempNote.value = { id: '', title: '', content: '', updated: '' };
}

// PUBLIC_INTERFACE
function onEditNote(note: Note) {
  mainMode.value = "edit";
  tempNote.value = { ...note };
}

// PUBLIC_INTERFACE
function onSaveNote(note: Note) {
  let isNew = mainMode.value === "new";
  if (isNew) {
    const fresh = {
      ...note,
      id: crypto.randomUUID ? crypto.randomUUID() : (Math.random()+'-'+Date.now()),
      updated: (new Date()).toISOString()
    };
    notes.value.unshift(fresh);
    selectedId.value = fresh.id;
  } else if (note.id) {
    const idx = notes.value.findIndex(n => n.id === note.id);
    if (idx !== -1) {
      notes.value[idx] = {
        ...note,
        updated: (new Date()).toISOString()
      };
      selectedId.value = note.id;
    }
  }
  tempNote.value = null;
  mainMode.value = "view";
}

// PUBLIC_INTERFACE
function onDeleteNote(note: Note) {
  if (!note?.id) return;
  const idx = notes.value.findIndex(n => n.id === note.id);
  if (idx !== -1) {
    notes.value.splice(idx, 1);
    if (selectedId.value === note.id) {
      selectedId.value = notes.value[0]?.id || null;
    }
  }
  tempNote.value = null;
  mainMode.value = "view";
}

// PUBLIC_INTERFACE
function onCancelEdit() {
  tempNote.value = null;
  mainMode.value = "view";
}
</script>

<template>
  <div class="notes-app-container">
    <NotesSidebar
      :notes="notes"
      :selectedId="selectedId"
      @select="onSelectNote"
      @new="onNewNote"
    />
    <main class="notes-main-area">
      <div class="main-header">
        <span v-if="mainMode==='new'" class="main-title accent">New Note</span>
        <span v-else-if="mainMode==='edit'" class="main-title secondary">Edit Note</span>
        <span v-else class="main-title primary">Note Details</span>
      </div>
      <section class="main-content">
        <NoteEditor
          v-if="mainMode==='new' || mainMode==='edit'"
          v-model="tempNote"
          :editing="true"
          @save="onSaveNote"
          @delete="onDeleteNote"
          @cancel="onCancelEdit"
        />
        <NoteView
          v-else
          :note="selectedNote"
          @edit="onEditNote"
        />
      </section>
    </main>
  </div>
</template>

<style>
.notes-app-root,
#app,
html, body {
  height: 100%;
  margin: 0; padding: 0;
  background: #F5F6FA; /* Very light bg */
  font-family: 'Inter', 'Segoe UI', Arial, sans-serif;
}
/* Main Layout */
.notes-app-container {
  display: flex;
  flex-direction: row;
  height: 97.5vh;
  margin: 1.2vh 1vw;
  background: #fff;
  border-radius: 16px;
  box-shadow: 0 6px 34px #e1e7ef55;
  min-width: 290px;
  min-height: 480px;
  max-width: 100vw;
  overflow: hidden;
}
.notes-main-area {
  flex: 1;
  display: flex;
  flex-direction: column;
  background: #fff;
  min-width: 0;
}

.main-header {
  padding: 1.7em 2em 1em 2em;
  border-bottom: 1px solid #F3F4F8;
  background: #feffff;
  font-size: 1.32em;
  font-weight: 600;
  letter-spacing: 0.02em;
  color: #3b3864;
  display: flex;
  align-items: center;
  min-height: 3.2em;
}
.main-title { font-weight: 600; }
.main-title.primary { color: #4F46E5; }
.main-title.accent { color: #EF4444; }
.main-title.secondary { color: #F59E42; }
.main-content {
  flex: 1;
  min-height: 0;
  overflow: auto;
  background: #fff;
}

@media (max-width: 650px) {
  .notes-app-container {
    flex-direction: column;
    height: auto;
    margin: 0;
    border-radius: 0;
    box-shadow: none;
  }
  .notes-main-area {
    border-left: none;
    width: 100%;
  }
}
</style>
