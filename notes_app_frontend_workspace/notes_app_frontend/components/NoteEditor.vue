<script setup lang="ts">
import { ref, watch, computed } from "vue";

const props = defineProps<{
  modelValue: { id?: string, title: string, content: string } | null,
  editing: boolean,
  loading?: boolean,
}>();
const emits = defineEmits<{
  (e: "update:modelValue", note: any): void;
  (e: "save", note: any): void;
  (e: "delete", note: any): void;
  (e: "cancel"): void;
}>();

const local = ref(
  props.modelValue
    ? { ...props.modelValue }
    : { title: "", content: "" }
);

watch(() => props.modelValue, (newVal) => {
  local.value = newVal ? { ...newVal } : { title: "", content: "" };
});

function save() {
  emits("save", { ...local.value });
}
function del() {
  emits("delete", { ...local.value });
}
function cancel() {
  emits("cancel");
}
function updateField(key: string, value: string) {
  local.value[key] = value;
  emits("update:modelValue", { ...local.value });
}
</script>

<template>
  <div v-if="local" class="note-editor">
    <input
      v-model="local.title"
      type="text"
      class="note-title"
      :placeholder="editing ? 'Note Title' : 'Untitled'"
      maxlength="50"
      @input="updateField('title', local.title)"
      :readonly="!editing"
    />
    <textarea
      v-model="local.content"
      :readonly="!editing"
      class="note-content"
      placeholder="Start writing your note here..."
      maxlength="8192"
      @input="updateField('content', local.content)"
    />
    <div class="note-actions" v-if="editing">
      <button
        class="save-btn"
        :disabled="props.loading || (!local.title && !local.content)"
        @click="save"
      >
        Save
      </button>
      <button
        class="delete-btn"
        v-if="local.id"
        @click="del"
        :disabled="props.loading"
      >
        Delete
      </button>
      <button class="cancel-btn" @click="cancel" :disabled="props.loading">
        Cancel
      </button>
    </div>
  </div>
  <div v-else class="note-empty">
    <p><i>No note selected.</i></p>
  </div>
</template>

<style scoped>
.note-editor {
  display: flex;
  flex-direction: column;
  height: 100%;
  padding: 2.1em 2em 1em 2em;
  font-family: 'Inter', sans-serif;
}
.note-title {
  font-size: 1.4em;
  font-weight: 600;
  margin-bottom: 0.7em;
  background: transparent;
  border: 0;
  border-bottom: 1.7px solid #F3F4F6;
  outline: none;
  padding: 0.5em 0.1em 0.35em 0.1em;
  color: #4F46E5;
  border-radius: 0;
  transition: border-color 0.18s;
}
.note-title:focus {
  border-bottom: 1.7px solid #EF4444;
}
.note-content {
  flex: 1;
  font-size: 1.07em;
  border: none;
  background: #F9FAFB;
  border-radius: 9px;
  resize: vertical;
  padding: 1em 1em;
  margin-bottom: 1.9em;
  margin-top: 0.3em;
  color: #0A1628;
  outline: none;
  min-height: 190px;
  line-height: 1.45;
}
.note-content:focus { background: #fffceb; }
.note-actions {
  display: flex;
  gap: 1em;
  margin-top: 0.6em;
}
.save-btn {
  background: #4F46E5;
  color: #fff;
  border: none;
  padding: 0.6em 2.2em;
  font-weight: 600;
  font-size: 1em;
  border-radius: 6px;
  cursor: pointer;
  transition: background 0.18s;
}
.save-btn:disabled { background: #a5b4fc; cursor: not-allowed; }
.save-btn:not(:disabled):hover { background: #3e37c4; }
.delete-btn {
  background: #fff;
  color: #EF4444;
  border: 1.5px solid #EF4444;
  padding: 0.6em 1.2em;
  font-weight: 600;
  border-radius: 6px;
  cursor: pointer;
  transition: background 0.17s, border 0.17s;
}
.delete-btn:hover { background: #fce4e4; border-color: #c72b2b; }
.cancel-btn {
  background: #F3F4F6;
  color: #293d62;
  border: none;
  padding: 0.6em 1.3em;
  font-weight: 500;
  border-radius: 6px;
  cursor: pointer;
  transition: background 0.15s;
}
.cancel-btn:hover { background: #e5e7eb; }
.note-empty {
  display: flex;
  align-items: center; justify-content: center;
  height: 100%;
  min-height: 230px;
  color: #bcbcbc;
  font-size: 1.2rem;
}
</style>
