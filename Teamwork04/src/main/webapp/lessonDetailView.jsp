
<%@ page import="java.util.ArrayList, aiwa.entity.Lesson, aiwa.entity.Flashcard" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="ja">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <title>Lesson Detail | LinguaTech</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css"
        rel="stylesheet">

    <link rel="stylesheet"
        href="${pageContext.request.contextPath}/style.css">

    <style>
        .lesson-detail-container {
            max-width: 850px;
            margin: auto;
        }

        .lesson-header {
            background: white;
            padding: 25px;
            border-radius: 16px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.05);
            margin-bottom: 30px;
        }

        .flashcard-wrap {
            max-width: 640px;
            margin: 0 auto;
        }

        .flashcard-box {
            background: white;
            border: 2px solid #b7dfc5;
            border-radius: 20px;
            min-height: 250px;
            padding: 32px 24px;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            text-align: center;
            cursor: pointer;
            box-shadow: 0 8px 25px rgba(25,135,84,0.08);
            transition: border-color 0.2s ease,
                        transform 0.15s ease,
                        box-shadow 0.2s ease;
        }

        .flashcard-box:hover {
            border-color: #198754;
            transform: translateY(-3px);
            box-shadow: 0 12px 28px rgba(25,135,84,0.13);
        }

        .flashcard-word {
            font-size: 2rem;
            font-weight: 700;
            line-height: 1.4;
            color: #146c43;
            word-break: break-word;
        }

        .flashcard-meaning {
            font-size: 1.35rem;
            color: #198754;
            margin-top: 12px;
            line-height: 1.5;
        }

        .flashcard-hint {
            font-size: 0.85rem;
            color: #8a9b90;
            margin-top: 18px;
        }

        .lesson-progress {
            height: 7px;
            border-radius: 10px;
            background: #dcefe3;
        }

        .lesson-progress .progress-bar {
            background: #198754;
            border-radius: 10px;
        }

        .next-lesson-box {
            background: #e8f5ed;
            border: 1px solid #b7dfc5;
            border-radius: 16px;
            padding: 25px;
            text-align: center;
        }

        .flashcard-controls .btn {
            padding: 11px;
            border-radius: 10px;
            font-weight: 600;
        }

        @media (max-width: 576px) {
            .flashcard-word {
                font-size: 1.6rem;
            }

            .flashcard-controls {
                flex-wrap: wrap;
            }

            .flashcard-controls .btn {
                min-width: 28%;
            }
        }
    </style>
</head>

<body>

<%
    Lesson lesson = (Lesson) request.getAttribute("lesson");

    ArrayList<Flashcard> cards =
        (ArrayList<Flashcard>) request.getAttribute("flashcards");

    Integer nextLessonId =
        (Integer) request.getAttribute("nextLessonId");

%>

<div class="container py-5 lesson-detail-container">

    <a href="LessonListController"
        class="text-decoration-none fw-semibold">
        ← Lesson List
    </a>

    <div class="lesson-header mt-3">

        <div class="text-success fw-semibold mb-2">
            🌿 LinguaTech Learning
        </div>

        <h1 class="mb-0">
            Lesson <%= lesson.getLessonNo() %>:
            <%= lesson.getTitle() %>
        </h1>

    </div>

    <h2 class="h4 mb-3">Flashcards (<%= cards == null ? 0 : cards.size() %>)</h2>

    <% if (cards == null || cards.isEmpty()) { %>

        <div class="alert alert-warning">
            No flashcards available for this lesson.
        </div>

    <% } else { %>

        <div class="flashcard-wrap">

            <div class="d-flex justify-content-between align-items-center mb-2 small text-secondary">
                <span id="sideLabel">WORD</span>

                <span id="cardCounter">
                    1 / <%= cards.size() %>
                </span>
            </div>

            <div class="progress lesson-progress mb-3">
                <div id="progressBar"
                    class="progress-bar"
                    role="progressbar"
                    style="width: 0%;">
                </div>
            </div>

            <div id="flashcardBox"
                class="flashcard-box"
                onclick="flipCard()">

                <div id="cardWord" class="flashcard-word"></div>

                <div id="cardMeaning"
                    class="flashcard-meaning"
                    style="display: none;">
                </div>

                <div id="cardHint" class="flashcard-hint">
                    Click to see translation
                </div>

            </div>

            <div class="d-flex gap-2 mt-3 flashcard-controls">

                <button type="button"
                    id="prevBtn"
                    class="btn btn-outline-success flex-fill"
                    onclick="prevCard()">
                    ← Previous
                </button>

                <button type="button"
                    id="flipBtn"
                    class="btn btn-primary flex-fill"
                    onclick="flipCard()">
                    Flip
                </button>

                <button type="button"
                    id="nextBtn"
                    class="btn btn-outline-success flex-fill"
                    onclick="nextCard()">
                    Next →
                </button>

            </div>


        </div>

        <script>
            const flashcardData = [

            <%
                for (int i = 0; i < cards.size(); i++) {

                    Flashcard f = cards.get(i);

                    String word = f.getWord() == null ? "" : f.getWord()
                        .replace("\\", "\\\\")
                        .replace("<", "\\u003c")
                        .replace("\"", "\\\"")
                        .replace("\r", "")
                        .replace("\n", "\\n");

                    String translated = f.getTranslated() == null ? "-" : f.getTranslated()
                        .replace("\\", "\\\\")
                        .replace("<", "\\u003c")
                        .replace("\"", "\\\"")
                        .replace("\r", "")
                        .replace("\n", "\\n");
            %>

                {
                    word: "<%= word %>",
                    translated: "<%= translated %>"
                }<%= (i < cards.size() - 1) ? "," : "" %>

            <%
                }
            %>

            ];

            let currentIdx = 0;
            let showAnswer = false;

            function updateFlashcardUI() {

                if (!flashcardData.length) return;

                const item = flashcardData[currentIdx];

                document.getElementById("cardCounter").textContent =
                    (currentIdx + 1) + " / " + flashcardData.length;

                document.getElementById("progressBar").style.width =
                    (((currentIdx + 1) / flashcardData.length) * 100) + "%";

                const sideLabel = document.getElementById("sideLabel");
                const wordEl = document.getElementById("cardWord");
                const meaningEl = document.getElementById("cardMeaning");
                const hintEl = document.getElementById("cardHint");

                if (!showAnswer) {

                    sideLabel.textContent = "WORD";

                    wordEl.textContent = item.word;

                    meaningEl.style.display = "none";
                    meaningEl.textContent = "";

                    hintEl.textContent = "Click to see translation";

                } else {

                    sideLabel.textContent = "TRANSLATION";

                    wordEl.textContent = item.word;

                    meaningEl.style.display = "block";
                    meaningEl.textContent = item.translated;

                    hintEl.textContent = "Click to hide translation";
                }

                const isLastCard =
                    currentIdx === flashcardData.length - 1;

                document.getElementById("prevBtn").disabled =
                    currentIdx === 0;

                document.getElementById("nextBtn").disabled =
                    isLastCard;

            }

            function flipCard() {

                showAnswer = !showAnswer;

                updateFlashcardUI();
            }

            function nextCard() {

                if (currentIdx < flashcardData.length - 1) {

                    currentIdx++;

                    showAnswer = false;

                    updateFlashcardUI();
                }
            }

            function prevCard() {

                if (currentIdx > 0) {

                    currentIdx--;

                    showAnswer = false;

                    updateFlashcardUI();
                }
            }

            updateFlashcardUI();

        </script>

    <% } %>

    <nav class="d-flex flex-wrap gap-2 mt-4" aria-label="Lesson actions">
        <a href="quiz?lessonId=<%= lesson.getLessonId() %>" class="btn btn-primary">Take Quiz</a>
        <% if (nextLessonId != null) { %>
        <a href="LessonDetailController?id=<%= nextLessonId %>" class="btn btn-outline-success">Next Lesson →</a>
        <% } %>
        <a href="HomeController" class="btn btn-outline-secondary">Home</a>
    </nav>

</div>

</body>
</html>
