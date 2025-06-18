import { useState, useEffect } from 'react';
import { keeper_backend } from 'declarations/keeper_backend';
import Note from './components/Note';
import CreateArea from './components/CreateArea';

function App() {
  const [notes, setNotes] = useState([]);

  useEffect(() => {
    fetchNotes();
  }, []);

  async function fetchNotes() {
    const notesArray = await keeper_backend.readNotes();
    setNotes(notesArray);
  }

  async function addNote(newNote) {
    await keeper_backend.createNote(newNote.title, newNote.content);
    fetchNotes();
  }

  async function deleteNote(id) {
    await keeper_backend.removeNote(id);
    fetchNotes();
  }

  return (
    <div>
      <header>
        <h1>Keeper</h1>
      </header>
      <CreateArea onAdd={addNote} />
      <div className="notes-container">
        {notes.map((note, index) => (
          <Note
            key={index}
            id={index}
            title={note.title}
            content={note.content}
            onDelete={deleteNote}
          />
        ))}
      </div>
    </div>
  );
}

export default App;
