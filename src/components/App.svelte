<style>
  /* vars defined in public/assets/global.css */
  h1 {
    font-size: 42px;
    text-align: center;
    margin: 2rem auto;
    max-width: 30rem;
  }
  figure {
    display: block;
    max-width: 30rem;
    margin: 0 auto;
    position: relative;
  }
  figure.right {
    outline: 8px solid lime;
  }
  figure.wrong {
    outline: 8px solid red;
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
  .choice,
  .next {
    text-align: center;
    display: flex;
    justify-content: space-between;
    max-width: 30rem;
    margin: 2rem auto;
    opacity: 0;
    transition: opacity 0.25s 0.75s;
  }
  .choice.visible,
  .next.visible {
    opacity: 1;
  }
  button {
    flex: 1 0 auto;
    font-size: 24px;
    padding: 1rem;
    cursor: pointer;
    /* font-family: "Times New Roman", Times, serif; */
    text-transform: uppercase;
    font-weight: bold;
  }
  button:first-of-type {
    margin-right: 0.5rem;
  }
  button:last-of-type {
    margin-left: 0.5rem;
  }
  button:hover {
    background-color: lightgray;
  }
</style>

<script>
  // import Child from "./Child.svelte";
  const url = "https://toe-or-thumb-db.herokuapp.com/answers";

  let mode = "question";
  let w = 0;
  let index = 0;
  let result;

  const data = ["toe"];

  $: h = w;

  function next() {}
  function submit() {
    const a = this.innerText.toLowerCase();
    result = a === data[index];
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

<h1>Is this a toe or thumb?</h1>

<figure
  class:right="{result === true}"
  class:wrong="{result === false}"
  style="height: {h}px;"
  bind:offsetWidth="{w}">
  <img
    class="visible"
    alt="image of toe or thumb?"
    src="assets/0-question.png" />
  <img
    class:visible="{mode === 'answer'}"
    alt="image revealed"
    src="assets/0-answer.png" />
</figure>

<div class="choice visible">
  <button disabled="{mode === 'answer'}" on:click="{submit}">Toe 🦶</button>
  <button disabled="{mode === 'answer'}" on:click="{submit}">Thumb ✋</button>
</div>

<div class:visible="{mode === 'answer'}" class="next">
  <button disabled="{mode === 'question'}" on:click="{next}">
    Next Appendage
  </button>
</div>
