// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import css from "../css/app.scss";

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import dependencies
//
import "phoenix_html";

import jQuery from "jquery";
window.jQuery = window.$ = jQuery; // Bootstrap requires a global "$" object.
import "bootstrap";
import _ from "lodash";

// Import local files
//
// Local files can be imported directly using relative paths, for example:
// import socket from "./socket"

$(function() {
  function new_hms(task_id) {
    $.ajax(`${timeblock_path}?task_id=${task_id}`, {
      method: "get",
      dataType: "json",
      contentType: "application/json; charset=UTF-8",
      data: "",
      success: resp => {
        let sum = _.sum(_.map(resp.data, timeblock => timeblock.duration));
        let d = Math.floor(sum / 86400);
        let h = Math.floor((sum % 86400) / 3600);
        let m = Math.floor((sum % 3600) / 60);
        let s = Math.floor(sum % 60);
        $("#hms").text(`${d}d, ${h}h, ${m}m, ${s}s`);
      }
    });
  }

  $("#timeblock-start").click(ev => {
    let task_id = $(ev.target).data("task-id");

    let text = JSON.stringify({
      timeblock: {
        todo_item_id: task_id
      }
    });

    $.ajax(timeblock_create, {
      method: "post",
      dataType: "json",
      contentType: "application/json; charset=UTF-8",
      data: text,
      success: _resp => {
        $("#timeblock-start").replaceWith(`<span id="timeblock-start"><h4>Tracking Time!</h4></span>`);
      }
    });
  });

  $("#timeblock-finish").click(ev => {
    let timeblock_id = $(ev.target).data("timeblock-id");

    let text = JSON.stringify({
      complete_block: true
    });

    $.ajax(`${timeblock_finish}/${timeblock_id}`, {
      method: "put",
      dataType: "json",
      contentType: "application/json; charset=UTF-8",
      data: text,
      success: resp => {
        $("#timeblock-finish").replaceWith(
          `<span id="timeblock-start"><h4>Time Updated!</h4></span>`
        );
        new_hms(resp.data.todo_item_id);
      }
    });
  });
});
