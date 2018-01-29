import { TweenMax, Power2, TimelineLite } from "gsap";

export default function() {
  $(document).on("click", ".add-generic-card-btn", function(e) {
    addCardToUser(e);
  });
  $(document).on("click", ".import-all-cards", function(e) {
    massImportCards(e);
  });

  function addCardToUser(e) {
    var $addButton = $(e.target);
    var csrf_token = $('input[name="csrf_token"]').val();
    var card_name = $('input[name="card_name"]').val();
    var user_id = $('input[name="user_id"]').val();
    var scryfall_uri = $('input[name="scryfall_uri"]').val();

    var params = { card: { name: card_name }, json_return: true };

    $.ajax({
      url: "/" + user_id + "/cards",
      type: "POST",
      beforeSend: function(xhr) {
        xhr.setRequestHeader("x-csrf-token", csrf_token);
      },
      data: params,
      success: function(response) {
        location.href = getDomain() + response.redirect_url;
      }
    });
  }

  function massImportCards(e) {
    $(".import-all-cards").hide();
    $("#loadContainer").show();
    var csrf_token = $('input[name="csrf_token"]').val();
    var user_id = $('input[name="user_id"]').val();

    $.ajax({
      url: "/" + user_id + "/mass-import-cards",
      type: "GET",
      beforeSend: function(xhr) {
        xhr.setRequestHeader("x-csrf-token", csrf_token);
      },
      data: {},
      success: function(response) {
        $("#loadContainer").hide();
        $(".import-all-cards").show();
      }
    });
  }

  function getDomain() {
    return (
      location.protocol +
      "//" +
      location.hostname +
      (location.port ? ":" + location.port : "")
    );
  }

  var pathStart =
    "M 28 2 L 17 16 L 23 16 L 9 34 L 17 34 L 3 52 L 19 52 L 19 57 ";
  var ptsDynamic = [
    [[19, 37], 57],
    [[19, 37], 52],
    [[3, 53], 52],
    [[17, 39], 34],
    [[9, 47], 34],
    [[23, 33], 16],
    [[17, 39], 16]
  ];

  var colors = ["#636567", "#869d7a"];
  var tweenPos = { path1: 0, path2: 0, currCol: 0, dur: 0.75 };

  var svgTreeContainer = document.getElementById("treeIcon"),
    path1 = document.getElementById("tree1"),
    path2 = document.getElementById("tree2");

  function bringIn() {
    path1.setAttribute("fill", colors[0]);
    TweenLite.to(tweenPos, tweenPos.dur, {
      path1: 1,
      ease: Power2.easeOut,
      onComplete: nextColor,
      onUpdate: function() {
        updateTree(path1, tweenPos.path1);
      },
      delay: 0.5
    });
  }

  function nextColor() {
    tweenPos.currCol++;
    path1.setAttribute("fill", colors[(tweenPos.currCol + 1) % 2]);
    path2.setAttribute("fill", colors[tweenPos.currCol % 2]);
    tweenPos.path2 = 0;
    updateTree(path2, 0);
    TweenLite.to(tweenPos, tweenPos.dur, {
      path2: 1,
      ease: Linear.easeInOut,
      onComplete: nextColor,
      onUpdate: function() {
        updateTree(path2, tweenPos.path2);
      }
    });
  }

  function updateTree(pathObj, perc) {
    var path = pathStart;
    for (var i = 0; i < ptsDynamic.length; i++) {
      path +=
        "L " +
        (ptsDynamic[i][0][0] +
          (ptsDynamic[i][0][1] - ptsDynamic[i][0][0]) * perc) +
        " " +
        ptsDynamic[i][1];
    }
    path += " z";
    pathObj.setAttribute("d", path);
  }

  //buildTree();
  //updateTree(path1, 1);
  bringIn();
}
