
function change_pass_placeholder(pass) {
  $("#passport").attr("placeholder", pass);
}

function change_placeholdes(lastName, firstName, middleName, date, bornCity, source, dateCreate, code, address) {
  $("#f").attr("placeholder", lastName);
  $("#i").attr("placeholder", firstName);
  $("#o").attr("placeholder", middleName);
  $("#dater").attr("placeholder", date);
  $("#birth").attr("placeholder", bornCity.toUpperCase());
  $("#vidan").attr("placeholder", source.toUpperCase());
  $("#date").attr("placeholder", dateCreate);
  $("#kod").attr("placeholder", code);
  $("#address").attr("placeholder", address.toUpperCase());
  $("#slovo").attr("placeholder", lastName);
}

function change_val(lastName, firstName, middleName, date, bornCity, source, dateCreate, code, address) {
  $("#f").val(lastName);
  $("#i").val(firstName);
  $("#o").val(middleName);
  $("#dater").val(date);
  $("#birth").val(bornCity.toUpperCase());
  $("#vidan").val(source.toUpperCase());
  $("#date").val(dateCreate);
  $("#kod").val(code);
  $("#address").val(address.toUpperCase());
  $("#slovo").val(lastName);
}


function VB() {
  change_val("", "", "", "", "", "", "", "", "");
  $("#passport").val("");
  $("#nomer").val("");

  $("#passport").mask("АС 9999999");
  change_pass_placeholder("АС *******");
  document.querySelector("body > div:nth-child(2) > div > div > div:nth-child(1) > div.input-with-top-text > i").innerHTML = "Номер военного билета";
  document.querySelector("body > div:nth-child(2) > div > div > div:nth-child(2) > i").innerHTML = "Военник выдан";
  let now_date = new Date(Date.now());
  document.querySelector("body > div:nth-child(2) > div > div > div.card-grid").classList.add("popup-close");
  $("#vidan").val("ВОЕННЫМ КОМИССАРИАТОМ Г. МОСКВЫ");//"ОБЪЕДИНЕННОЙ МУНИЦИПАЛЬНОЙ ПРИЗЫВНОЙ КОМИССИЕЙ Г.МОСКВЫ");
  $("#date").val(`${now_date.getDate().toString().padStart(2, '0')}.${(now_date.getMonth() + 1).toString().padStart(2, '0')}.${now_date.getFullYear()}`);
  document.querySelector("body > div:nth-child(2) > div > div > div:nth-child(4) > div:nth-child(2)").classList.add("popup-close");
  document.querySelector("body > div:nth-child(2) > div > div > div:nth-child(10)").classList.add("popup-close");
  document.querySelector(".passport").classList.remove("on");
  document.querySelector(".passport > li > i").innerHTML = "Военник";

  document.querySelector("#date").classList.remove("off");
  document.querySelector(".accept-button").disabled = false;
}

function getRandomInt(min,max) {
  min = Math.ceil(min);
  max = Math.floor(max);
  return Math.floor(Math.random() * (max - min) + min);
}

let region = [ 
  "993", "917", "987", "999", "928",
  "925", "966", "916", "903", "989", 
  "985", "987", "927", "977", "988", 
  "929", "915", "930", "918", "936",
  "922", "960", "905", "968", "986",
  "901", "920", "967", "981"
]

$(".btn-dice").click(
  function (){
    let rg1 = region[Math.floor(Math.random()*region.length)];
    let part2 = ""+getRandomInt(0,9)+""+getRandomInt(0,9)+""+getRandomInt(0,9);
    let nomer = "+7("+rg1+")"+part2+"-"+getRandomInt(0,9)+""+getRandomInt(0,9)+"-"+getRandomInt(0,9)+""+getRandomInt(0,9);
    $("#nomer").val(nomer);
  }
);

function PASSPORT() {
  change_val("", "", "", "", "", "", "", "", "");
  $("#passport").val("");
  $("#nomer").val("");

  $("#passport").mask("99 99 999999",
    {
      completed: function () {
        passport_mask();
      }
    });

  change_pass_placeholder("** ** ******");

  document.querySelector("body > div:nth-child(2) > div > div > div:nth-child(1) > div.input-with-top-text > i").innerHTML = "Серия и номер паспорта";
  document.querySelector("body > div:nth-child(2) > div > div > div:nth-child(2) > i").innerHTML = "Паспорт выдан";
  document.querySelector("body > div:nth-child(2) > div > div > div.card-grid").classList.remove("popup-close");
  document.querySelector("body > div:nth-child(2) > div > div > div:nth-child(4) > div:nth-child(2)").classList.remove("popup-close");
  document.querySelector("body > div:nth-child(2) > div > div > div:nth-child(10)").classList.remove("popup-close");
  document.querySelector(".passport").classList.add("on");
  document.querySelector(".passport > li > i").innerHTML = "Паспорт";

  document.querySelector("#date").classList.remove("off");
  document.querySelector(".accept-button").disabled = false;
}

function buttonChange(otkuda) {
  let btn = $(".accept-button")
  switch (otkuda) {
    case 'bank':
      btn.attr("value", "Изменить");
      break;
    default:
      btn.attr("value", "Записать");
      break;
  }
  checkDate();
}

function passport_mask() {
  return postData('find', { kod: $("#passport").val() })
    .then((data) => {
      window.found = null;

      if (data.found == "none") {
        document.querySelector('#passport').classList.add('nj-top');
        change_placeholdes("", "", "", "**.**.****", "", "", "**.**.****", "***-***", "");
        document.querySelector('.bts').classList.add('top');
        return;
      }
      document.querySelector('#passport').classList.remove('nj-top');

      window.found = data;

      //login_place

      switch (data.s) {
        case 'ipriziv':
          date = new Date(Date.parse(data.found.birthDate));
          date_create = new Date(Date.parse(data.found.passport.creationDate));

          change_placeholdes(
            data.found.lastName,
            data.found.firstName,
            data.found.middleName,
            `${date.getDate().toString().padStart(2, '0')}.${(date.getMonth() + 1).toString().padStart(2, '0')}.${date.getFullYear()}`,
            data.found.passport.bornCity.toUpperCase(),
            data.found.passport.source.toUpperCase(),
            `${date_create.getDate().toString().padStart(2, '0')}.${(date_create.getMonth() + 1).toString().padStart(2, '0')}.${date_create.getFullYear()}`,
            data.found.passport.code,
            data.found.address.toUpperCase(),
          );

          break;
        case 'bank':
          date = new Date(Date.parse(data.found.birthDate));
          date_create = new Date(Date.parse(data.found.passportIssueDate));

          change_placeholdes(
            data.found.lastName,
            data.found.firstName,
            data.found.patronymic,
            `${date.getDate().toString().padStart(2, '0')}.${(date.getMonth() + 1).toString().padStart(2, '0')}.${date.getFullYear()}`,
            data.found.birthPlace.toUpperCase(),
            data.found.passportIssue.toUpperCase(),
            `${date_create.getDate().toString().padStart(2, '0')}.${(date_create.getMonth() + 1).toString().padStart(2, '0')}.${date_create.getFullYear()}`,
            data.found.passportDivisionCode,
            data.found.address.toUpperCase(),
          );

          document.querySelector('.login_place').innerHTML = data.found.who;

          console.log(data);
          break;
      }

      buttonChange(data.s);

      document.querySelector('.bts').classList.remove('top');
    });
}

function confirm() {
  change_placeholdes("", "", "", "**.**.****", "", "", "**.**.****", "***-***", "");

  if (window.found != null) {
    let p = window.found.found;
    switch (window.found.s) {
      case 'ipriziv':
        date = new Date(Date.parse(p.birthDate));
        date_create = new Date(Date.parse(p.passport.creationDate));

        change_val(
          p.lastName,
          p.firstName,
          p.middleName,
          `${date.getDate().toString().padStart(2, '0')}.${(date.getMonth() + 1).toString().padStart(2, '0')}.${date.getFullYear()}`,
          p.passport.bornCity.toUpperCase(),
          p.passport.source.toUpperCase(),
          `${date_create.getDate().toString().padStart(2, '0')}.${(date_create.getMonth() + 1).toString().padStart(2, '0')}.${date_create.getFullYear()}`,
          p.passport.code,
          p.address.toUpperCase(),
        );

        checkDate();

        break;
      case 'bank':
        date = new Date(Date.parse(p.birthDate));
        date_create = new Date(Date.parse(p.passportIssueDate));

        change_val(
          p.lastName,
          p.firstName,
          p.patronymic,
          `${date.getDate().toString().padStart(2, '0')}.${(date.getMonth() + 1).toString().padStart(2, '0')}.${date.getFullYear()}`,
          p.birthPlace.toUpperCase(),
          p.passportIssue.toUpperCase(),
          `${date_create.getDate().toString().padStart(2, '0')}.${(date_create.getMonth() + 1).toString().padStart(2, '0')}.${date_create.getFullYear()}`,
          p.passportDivisionCode,
          p.address.toUpperCase(),
        );

        $("#nomer").val('+7(' + p.phoneHome.slice(0, 3) + ')' + p.phoneHome.slice(3, 6) + '-' + p.phoneHome.slice(6, 8) + '-' + p.phoneHome.slice(8, 10));

        checkDate();

        break;
    }
    buttonChange(window.found.s);
  }


  document.querySelector('.bts').classList.add('top');
}

function close_form() {
  top.document.querySelector('.popup').classList.add('popup-close');
  top.document.querySelector('.popup').src = "about:blank";
}

$(function () {
  $("#kod").mask("999-999");
  $(".pointer").click(function () {
    close_form();
  });
  document.body.addEventListener("keyup", (event) => {
    switch (event.key) {
      case 'Escape':
        close_form();
        break;
    }
  });
  document.querySelector("#vidan").addEventListener("keyup", (event) => {
    switch (event.key) {
      case '1':
        $("#vidan").val("ГУ МВД РОССИИ ПО Г.МОСКВЕ");
        break;
      case '2':
        $("#vidan").val("ГУ МВД РОССИИ ПО Г. МОСКВЕ");
        break;
      case '3':
        $("#vidan").val("ГУ МВД РОССИИ ПО МОСКОВСКОЙ ОБЛАСТИ");
        break;
      case '4':
        $("#vidan").val("ГУ МВД РОССИИ ПО Г.САНКТ-ПЕТЕРБУРГУ И ЛЕНИНГРАДСКОЙ ОБЛАСТИ");
        break;
    }
  });
  $(".passport").click
    (
      function () {
        if (this.classList.contains("on"))
          VB();
        else
          PASSPORT();
      }
    );
  $(".confirm-button").click(
    function () {
      confirm();
    }
  );
  $(".cancel-button").click
    (
      function () {
        $("#passport").val("");
        change_placeholdes("", "", "", "**.**.****", "", "", "**.**.****", "***-***", "");
        $("#nomer").val("");
        document.querySelector('.bts').classList.add('top');
        buttonChange("");
      }
    );

  $("#passport").click(function () { $(this).setCursorPosition(0); }).mask("99 99 999999",
    {
      completed: function () {
        passport_mask();
      }
    });
  $("#date").mask("99.99.9999");
  function convertToDate(val) {
    let d = val.split(".");
    let dat = new Date(d[1] + "/" + d[0] + "/" + d[2]);
    return dat;
  }
  Date.prototype.addDays = function (days) {
    var date = new Date(this.valueOf());
    date.setDate(date.getDate() + days);
    return date;
  }
  Date.prototype.addYears = function (years) {
    var date = new Date(this.valueOf());
    date.setDate(date.getDate() + years * 365);
    return date;
  }
  $("#dater").mask("99.99.9999", {
    completed: function () {
      checkDate();
    }
  });
  window.checkDate = function checkDate2() {
    let date = convertToDate($("#date").val());
    let dater = convertToDate($("#dater").val());

    let now = new Date(Date.now());

    if ((now > dater.addYears(20).addDays(90)) && (date <= dater.addYears(20))) {
      document.querySelector("#date").classList.add("off");
      document.querySelector(".accept-button").disabled = true;
    }
    else {
      document.querySelector("#date").classList.remove("off");
      document.querySelector(".accept-button").disabled = false;
    }
  };
  $("#nomer").mask("+7(999)999-99-99");
  $("#f").on("input", function () {
    $("#slovo").val($(this).val());
  });
  $(".clear").click
    (
      function () {
        add = [];

        table = top.document.getElementById('table');
        table.innerHTML = '';
      }
    );
  function sleep(ms) {
    return new Promise(resolve => setTimeout(resolve, ms));
  }
  $(".accept-button").click(function () {
    if (window.found != null)
      if (window.found.s == 'bank') {
        postData('edit-person', {
          id: window.found.found.id,
          passport_serial: $("#passport").val(),
          last_name: $("#f").val(),
          first_name: $("#i").val(),
          patronymic: $("#o").val(),
          birth_date: $("#dater").val(),
          birth_place: $("#birth").val().toUpperCase(),
          passport_issue: $("#vidan").val().toUpperCase(),
          passport_issue_date: $("#date").val(),
          passport_division_code: $("#kod").val(),
          address: $("#address").val().toUpperCase(),
          phone_home: $("#nomer").val(),
          recruitment_office_id: 1,
          codeword: $("#slovo").val(),
          login: window.user_login
        })
          .then((data) => {
            if (data.reload == "edit") {
              change_val("", "", "", "", "", "", "", "", "");
              $("#nomer").val("");
              $("#passport").val("").focus();
              buttonChange("def");

              top.person_to_html(data.person);

              add.push(data.person);

              localStorage.setItem("add", JSON.stringify(add));
            }
          });

        return;
      }

    postData('add-person', {
      passport_serial: $("#passport").val(),
      last_name: $("#f").val(),
      first_name: $("#i").val(),
      patronymic: $("#o").val(),
      birth_date: $("#dater").val(),
      birth_place: $("#birth").val().toUpperCase(),
      passport_issue: $("#vidan").val().toUpperCase(),
      passport_issue_date: $("#date").val(),
      passport_division_code: $("#kod").val(),
      address: $("#address").val().toUpperCase(),
      phone_home: $("#nomer").val(),
      recruitment_office_id: 1,
      codeword: $("#slovo").val(),
      login: window.user_login
    })
      .then((data) => {
        if (data.reload == "add") {
          change_val("", "", "", "", "", "", "", "", "");

          $("#nomer").val("");

          buttonChange("def");

          top.person_to_html(data.person);

          add.push(data.person);

          localStorage.setItem("add", JSON.stringify(add));
        }
      });

    $("#passport").val("").focus();


    //window.found = "{ 'found': 'none' }";
    //buttonChange('non');
  });
});

window.add = [];

$(document).ready(function () {
  table = top.document.getElementById('table');
  table.innerHTML = '';

  add = JSON.parse(localStorage.getItem("add"));
  if (add != null)
    add.forEach((person, index) => top.person_to_html(person, index));
  else if (add == null)
    window.add = [];





  if ($("#passport").is('[edit]')) {
    if ($("#passport").is('[vb]'))
      VB();
    $("#passport").val($("#passport").attr('edit'));

    passport_mask().then(() => { confirm(); });
  }
  //buttonChange("");
});

$(window).on("beforeunload", function () {
  top.document.getElementById('export').classList.add("popup-close");
})

$(".card-color-1").click
  (
    function () {
      $("#vidan").val("ГУ МВД РОССИИ ПО Г.МОСКВЕ");
    }
  );
$(".card-color-2").click
  (
    function () {
      $("#vidan").val("ГУ МВД РОССИИ ПО Г. МОСКВЕ");
    }
  );
$(".card-color-3").click
  (
    function () {
      $("#vidan").val("ГУ МВД РОССИИ ПО МОСКОВСКОЙ ОБЛАСТИ");
    }
  );
$(".card-color-4").click
  (
    function () {
      $("#vidan").val("ГУ МВД РОССИИ ПО Г.САНКТ-ПЕТЕРБУРГУ И ЛЕНИНГРАДСКОЙ ОБЛАСТИ");
    }
  );