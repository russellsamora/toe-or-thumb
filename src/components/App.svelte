<style>
  /* vars defined in public/assets/global.css */
  h1 {
    font-size: 4rem;
    text-align: center;
  }
  figure {
    display: block;
    max-width: 30rem;
    margin: 0 auto;
    position: relative;
  }
  img {
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    opacity: 0;
    /* transition: opacity 250ms; */
  }
  img.visible {
    opacity: 1;
  }
  .choice {
    text-align: center;
    display: flex;
    justify-content: space-between;
    max-width: 30rem;
    margin: 1rem auto;
  }
  button {
    flex: 1 0 auto;
    font-size: 24px;
    padding: 1rem;
    cursor: pointer;
    font-family: "Times New Roman", Times, serif;
  }
  button:first-of-type {
    margin-right: 0.5rem;
  }
  button:last-of-type {
    margin-left: 0.5rem;
  }
  button:hover {
    background-color: pink;
  }
</style>

<script>
  // import Child from "./Child.svelte";
  const url = "https://toe-or-thumb-db.herokuapp.com/answers";

  let mode = "question";
  let w = 0;

  $: h = w;

  function submit() {
    mode = "answer";
  }

  function post() {
    const request = new XMLHttpRequest();
    request.open("POST", url, true);
    request.setRequestHeader(
      "Content-Type",
      "application/x-www-form-urlencoded; charset=UTF-8"
    );

    request.onload = function() {
      if (this.status >= 200 && this.status < 400) {
      } else {
      }
    };

    request.onerror = function() {};

    request.send({ question: 0, answer: false });
  }
</script>

<h1>Toe or Thumb?</h1>

<figure style="height: {h}px;" bind:offsetWidth="{w}">
  <img
    class="visible"
    alt="image of toe or thumb?"
    src="assets/0-question.png" />
  <img
    class:visible="{mode === 'answer'}"
    alt="image revealed"
    src="assets/0-answer.png" />
</figure>

<div class="choice">
  <button on:click="{submit}">Toe</button>
  <button on:click="{submit}">Thumb</button>
</div>
