<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Upgrade to Pro</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
    <style>
        body {
            background-color: #0f172a;
            color: #f8fafc;
        }
        .pricing-card {
            background-color: #1e293b;
            border: 1px solid #334155;
            border-radius: 16px;
        }
        .pricing-card.featured {
            border: 2px solid #38bdf8;
            box-shadow: 0 12px 30px rgba(56, 189, 248, 0.14);
        }
        .checkout-box {
            background-color: #1e293b;
            border: 1px solid #334155;
            border-radius: 16px;
        }
    </style>
</head>
<body class="py-5">
<%
    String lessonNo = request.getParameter("lessonNo");
    if (lessonNo == null || lessonNo.isEmpty()) {
        lessonNo = "5";
    }
%>

<div class="container" style="max-width: 780px;">
    <div class="text-center mb-4">
        <span class="badge text-bg-info mb-2">LESSON <%= lessonNo %>+ LOCKED</span>
        <h1 class="fw-bold">Upgrade Your Learning Plan</h1>
        <p class="text-secondary mb-0">
            Continue from Lesson <%= lessonNo %> with full access to all remaining lessons and flashcards.
        </p>
    </div>

    <!-- Plans -->
    <div class="row g-4 mb-4">
        <div class="col-md-6">
            <div class="pricing-card p-4 h-100">
                <div class="text-secondary small fw-semibold">STARTER</div>
                <h3 class="fw-bold mt-1 mb-2">Free Plan</h3>
                <div class="fs-2 fw-bold mb-3">$0 <span class="fs-6 fw-normal text-secondary">/ month</span></div>
                <ul class="list-unstyled text-secondary small mb-0">
                    <li class="mb-2">✓ Access to Lessons 1–4</li>
                    <li class="mb-2">✓ Interactive Flashcards</li>
                    <li class="mb-0">✕ Lessons 5–10 locked</li>
                </ul>
            </div>
        </div>

        <div class="col-md-6">
            <div class="pricing-card featured p-4 h-100">
                <div class="d-flex justify-content-between align-items-center">
                    <span class="text-info small fw-semibold">RECOMMENDED</span>
                    <span class="badge text-bg-primary">Pro</span>
                </div>
                <h3 class="fw-bold mt-1 mb-2">Pro Learner</h3>
                <div class="fs-2 fw-bold mb-3">\9,9999<span class="fs-6 fw-normal text-secondary">/ month</span></div>
                <ul class="list-unstyled text-light small mb-0">
                    <li class="mb-2">✓ Unlock Lessons 5–10 immediately</li>
                    <li class="mb-2">✓ Full Flashcard Deck Access</li>
                    <li class="mb-0">✓ Priority Study Flow</li>
                </ul>
            </div>
        </div>
    </div>

   <div id="seriousCheckout" class="checkout-box p-4">
        <div class="d-flex justify-content-between align-items-center mb-3">
            <h5 class="fw-semibold mb-0">Payment Details</h5>
            <a href="LessonListController" class="btn btn-outline-warning btn-sm">Run away 🏃</a>
        </div>
        <form onsubmit="triggerJokeTwist(event)">
            <div class="row g-3">
                <div class="col-md-6">
                    <label class="form-label small text-secondary">Cardholder Name</label>
                    <input type="text" class="form-control bg-dark text-light border-secondary" placeholder="Taro Yamada" required>
                </div>
                <div class="col-md-6">
                    <label class="form-label small text-secondary">Card Number</label>
                    <input type="text" class="form-control bg-dark text-light border-secondary" placeholder="4242 •••• •••• 4242" required>
                </div>
                <div class="col-6">
                    <label class="form-label small text-secondary">Expiry Date</label>
                    <input type="text" class="form-control bg-dark text-light border-secondary" placeholder="12/28" required>
                </div>
                <div class="col-6">
                    <label class="form-label small text-secondary">CVC</label>
                    <input type="text" class="form-control bg-dark text-light border-secondary" placeholder="999" required>
                </div>
            </div>

            <div class="d-flex justify-content-end mt-4">
                <button type="submit" class="btn btn-info fw-semibold px-4">Pay ¥99,999 Now</button>
            </div>
        </form>
    </div>

    <div id="jokeTwistBox" class="alert alert-warning text-dark rounded-4 p-4 mt-4" style="display: none;">
        <div class="fw-bold mb-1">Just kidding! No payment here.</div>
        <div class="small mb-3">Thanks for your attention</div>
        <div class="d-flex flex-wrap gap-2">
            <a href="LessonListController" class="btn btn-dark btn-sm">Run away 🏃</a>
            <button type="button" class="btn btn-outline-dark btn-sm" onclick="resetCheckout()">Try Again</button>
        </div>
    </div>
</div>

<script>
    function triggerJokeTwist(event) {
        event.preventDefault();
        document.getElementById("seriousCheckout").style.display = "none";
        document.getElementById("jokeTwistBox").style.display = "block";
    }

    function resetCheckout() {
        document.getElementById("jokeTwistBox").style.display = "none";
        document.getElementById("seriousCheckout").style.display = "block";
    }
</script>
</body>
</html>