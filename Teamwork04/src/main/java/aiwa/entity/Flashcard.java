package aiwa.entity;

public class Flashcard {

	private int flashcardId;
	private String word;
	private String translated;

	public int getFlashcardId() {
		return flashcardId;
	}

	public void setFlashcardId(int flashcardId) {
		this.flashcardId = flashcardId;
	}

	public String getWord() {
		return word;
	}

	public void setWord(String word) {
		this.word = word;
	}

	public String getTranslated() {
		return translated;
	}

	public void setTranslated(String translated) {
		this.translated = translated;
	}
}