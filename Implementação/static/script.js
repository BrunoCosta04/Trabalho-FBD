//-----------------------------------uso geral-------------------------------//
function getById(isso) {
  return document.getElementById(isso).value;
}

function goToLoc(location, parameters) {
  let url = new URL(window.location.href);
  if (parameters == undefined) {
    window.location.href = location;
  } else {
    window.location.href = location + parameters;
  }
}

function mostra(id) {
  document.getElementById(id).hidden = false;
}

function esconde(id) {
  document.getElementById(id).hidden = true;
}
