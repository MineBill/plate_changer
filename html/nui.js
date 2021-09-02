$("#plate-form").submit(e => {
   e.preventDefault();
   const text = $("#plate-text").val().toUpperCase();
   if (text.length !== 0) {
       $.post(`https://${GetParentResourceName()}/change_plate`, JSON.stringify({
           plate: text
       }));
   }
   $("#plate").hide();
});

$("#plate-text").on("input", function() {
    let c = this.selectionStart,
        r = /[^a-z0-9 ]/gi,
        v = $(this).val();
    if (r.test(v)) {
        $(this).val(v.replace(r, ""));
        c--;
    }
    this.setSelectionRange(c, c);
});

window.addEventListener("message", event => {
    switch (event.data.type) {
        case "enable": {
            $("#plate").show();
            $("#plate-text").val("");
            break;
        }
    }
});
