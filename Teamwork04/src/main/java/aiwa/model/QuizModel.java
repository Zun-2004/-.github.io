package aiwa.model;

import java.util.List;

public class QuizModel {
	private int flashcardId;
	private String promptWord;
	private String correctAnswer;
	private List<String> options;

	public QuizModel(int flashcardId, String promptWord, String correctAnswer, List<String> options) {
		this.flashcardId = flashcardId;
		this.promptWord = promptWord;
		this.correctAnswer = correctAnswer;
		this.options = options;
	}

	public int getFlashcardId() {
		return flashcardId;
	}

	public String getPromptWord() {
		return promptWord;
	}

	public String getCorrectAnswer() {
		return correctAnswer;
	}

	public List<String> getOptions() {
		return options;
	}
}