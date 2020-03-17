<style>
  /* vars defined in public/assets/global.css */
  h1 {
    font-size: 40px;
    font-weight: 400;
    text-align: center;
    margin: 2rem auto;
    /* max-width: var(--w); */
  }
  figure {
    display: block;
    /* max-width: var(--w); */
    min-height: 280px;
    margin: 0 auto;
    position: relative;
  }

  figure:before {
    position: absolute;
    display: block;
    top: 1rem;
    right: 1rem;
    font-size: 48px;
    z-index: 1;
    line-height: 1;
  }
  figure.right:before {
    content: "✅";
  }
  figure.wrong:before {
    content: "🚫";
  }

  img {
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    opacity: 0;
  }
  img.visible {
    opacity: 1;
  }
  .choice {
    text-align: center;
    display: flex;
    justify-content: space-between;
    /* max-width: var(--w); */
    margin: 2rem auto;
    opacity: 0;
    transition: opacity 0.25s 0.75s;
  }
  .choice.visible {
    opacity: 1;
  }
  button {
    flex: 1 0 auto;
    font-size: 20px;
    padding: 0.5rem;
    cursor: pointer;
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
  .next {
    /* max-width: var(--w); */
    margin: 0 auto;
    line-height: 1.4;
    visibility: hidden;
  }
  .next.visible {
    visibility: visible;
  }
  .credit {
    /* max-width: var(--w); */
    margin: 0 auto;
    line-height: 1.4;
  }
  @media only screen and (min-width: 480px) {
    button {
      padding: 1rem;
      font-size: 24px;
    }
  }
</style>

<script>
  import { onMount } from "svelte";
  const data = ["thumb"];

  let mode = "question";
  let w = 0;
  let index = 0;
  let user = [];
  let agg = [];

  $: h = w;
  $: result = user[index] ? user[index] === data[index] : null;
  $: currentAgg = agg.length ? agg.find(d => d.key === `${index}`) : null;
  $: numR = currentAgg ? currentAgg.value.r : 0;
  $: numW = currentAgg ? currentAgg.value.w : 0;
  $: percent = currentAgg
    ? `${Math.round((numR / (numR + numW)) * 100)}%`
    : "0%";

  function getAggregate() {
    const request = new XMLHttpRequest();
    const version = Date.now();
    const url = `https://pudding.cool/misc/toe-or-thumb/data.json?version=${version}`;
    request.open("GET", url, true);

    request.onload = function() {
      if (this.status >= 200 && this.status < 400) {
        const raw = JSON.parse(this.response);
        agg = raw.answers;
      } else {
        console.log("error1");
      }
    };

    request.onerror = function() {
      console.log("error2");
    };

    request.send();
  }

  onMount(() => {
    // localStorage.removeItem("toe-or-thumb");
    const str = localStorage.getItem("toe-or-thumb");
    if (str) {
      user = JSON.parse(str);
      mode = "answer";
    }
    getAggregate();
  });

  function submit() {
    const a = this.innerText.toLowerCase();
    user[index] = a;
    user = user;
    mode = "answer";

    localStorage.setItem("toe-or-thumb", JSON.stringify(user));
    saveToDB({ question: index, answer: a === data[index] });
  }

  function saveToDB(result) {
    const request = new XMLHttpRequest();
    const url = "https://toe-or-thumb-db.herokuapp.com/answers";
    request.open("POST", url, true);
    request.setRequestHeader("Content-Type", "application/json");
    request.onload = function() {
      console.log(this.status);
    };
    request.onerror = function(err) {
      console.log(err);
    };
    request.send(JSON.stringify(result));
  }
</script>

<h1>Toe or Thumb?</h1>

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
  <button disabled="{mode === 'answer'}" on:click="{submit}">Toe</button>
  <button disabled="{mode === 'answer'}" on:click="{submit}">Thumb</button>
</div>

<div class:visible="{mode === 'answer' && agg.length}" class="next">
  <p>
    <span>{percent}</span>
    of people got it! {numR} ✅ and {numW} 🚫.
  </p>
</div>

<div class="credit">
  <p>Check back next week for round {index + 2}!</p>
  <p>
    Made by
    <a href="https://twitter.com/codeberg" target="_blank">@codenberg</a>

  </p>
</div>
