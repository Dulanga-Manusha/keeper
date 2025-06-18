import List "mo:base/List";
import Debug "mo:base/Debug";

/**
 * Keeper - A decentralized note-keeping application
 * 
 * This canister provides functionality for creating, reading, and deleting notes
 * in a persistent storage environment on the Internet Computer.
 */
actor Keeper {

    /**
     * Note - Data structure representing a single note entry
     * 
     * @field title - The title of the note
     * @field content - The main content/body of the note
     */
    public type Note = {
        title: Text;
        content: Text;
    };

    /**
     * Stable variable to persist notes across canister upgrades.
     * Uses a linked list data structure for efficient prepend operations.
     */
    stable var notes: List.List<Note> = List.nil<Note>();

    /**
     * Creates a new note and adds it to the notes collection
     * 
     * @param titleText - The title for the new note
     * @param contentText - The content for the new note
     */
    public func createNote(titleText: Text, contentText: Text) {
        let newNote: Note = {
            title = titleText;
            content = contentText;
        };

        // Add the new note to the beginning of the list for O(1) insertion
        notes := List.push(newNote, notes);
        Debug.print(debug_show(notes));
    };

    /**
     * Retrieves all notes from the collection
     * 
     * @return An array containing all notes
     */
    public query func readNotes(): async [Note] {
        return List.toArray(notes);
    };

    /**
     * Removes a note at the specified index
     * 
     * @param id - The index of the note to remove
     */
    public func removeNote(id: Nat) {
        // Split the list at the specified index
        let listFront = List.take(notes, id);
        let listBack = List.drop(notes, id + 1);
        
        // Reconstruct the list without the element at the specified index
        notes := List.append(listFront, listBack);
    };
}
