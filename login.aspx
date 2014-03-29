

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1"><title>
	ENI Training
</title><link rel="shortcut icon" type="image/x-icon" href="styles/default/images/favicon.ico" />
    <script type="text/javascript" src="include/scripts/jquery-1.10.2.min.js"></script>
    <script type="text/javascript" src="include/scripts/jquery-ui-1.10.3.custom.min.js"></script>
    <script type="text/javascript" src="include/scripts/purl.js"></script>

<link rel="stylesheet" href="styles/default/css/common.css" type="text/css" /><link rel="stylesheet" href="styles/default/css/login.css" type="text/css" /></head>

<body class="C3_background" onload="">
	<form method="post" action="login.aspx?cfgsite=Default&amp;cfgbdd=LIVRES_GRATUITS" id="form1">
<div class="aspNetHidden">
<input type="hidden" name="__VIEWSTATE" id="__VIEWSTATE" value="F0jFBydw00lJpoT+lVYnJjugItFJ4AZdYdqdJdRgciJasvn9lYUSKbRdc7K0wfHrsOGPast+Tw4QKbMpHmlLVHGtx9Vr4vq0huVGhgNVRDKCqr/QvUTM3vF5w4OayYUVllqFGesbsDM2Rjz+t42KQfkXlC6MjrX29EK2NVlpNIqGxnf7vu/YxTc+TwqIguasRK0GvRz3sMqA//CSsvRcoM365m8avn3uQ848xwAFUbPbzGmJf3fv4asZSycIh1rsx5H5t5pG9wBScA05gCn8J65Flw7Arruy8I3UjzgU84DLqAbhMO70TNAbtf8V4wduXaC8AeUMplmAQb8LGghkxfWzdwfaRavMlzhnvpln5k8dw6qprdI/u/HlQoNG5XHK3VmjIhBS0tEZdgMbWhBFm8nmNMGyz1sFeTf3zbfY3XfK+odASItV0T4Z4K8A96XEbeBFT/ajDtUMC55bYdFI4sbE6BgN3lMHDknsxo3WKB0x7f3hHR7IAFxB7DZ0/2u5CZAbZYCDSAzhr0gu9WWCN943uUzbRgDn6B8W+yzaxB47RmSaAD+0bdEn9mptVtnII89+TW5Y0kBkJYwteUMtFqPnm4VIl2ZJuctXcSHmroA=" />
</div>


<script type="text/javascript">
//<![CDATA[

// Constantes de langues
//------------------------------
var lngLN = "Livre numérique";
var lngVideo = "Vidéo";
var lngSearchDefaultText = "Rechercher";
var lngNext = "Suivant&nbsp;&nbsp;>";
var lngPrev = "<&nbsp;&nbsp;Précédent";
var lngBookmarks = "Retirer de mes favoris";
var lngAddToBookmarks = "Ajouter à mes favoris";
var lngNoBookmark = "";
var lngLoading = "%LOADING%";

// Référence sur le DOM
//--------------------------
var $SearchEngine;
var $client_mnu;
		
// fonctions/procédures diverses
//------------------------------
function showMsgBox(Params) { /*(Params = {Position:{Top:...,Left:...}, 											(Facultatif (non renseigné par défaut) : Permet le positionnement personnalisé de la boite de message.)
										  Type:"Alert/Confirm",  												(Facultatif ('Alert' par défaut) : ('Alert' = un seul bouton à paramétrer "Ok", 'Confirm' = 2 boutons "Ok" "Cancel")
										  Title:"...",  														(Titre de la boite de dialogue)
										  Content:"...", 														(Contenu)
										  Ok:{Title:"...",fn:function({...;return true/false;})},				(Title=Libellé, fn=fontion à exécuter lors du click suivi de return true=fermeture de la boite de dialogue/false=pas de fermeture (fn facultatif))
										  Cancel:{Title:"...",fn:function({...;return true/false;})}			(Title=Libellé, fn=fontion à exécuter lors du click suivi de return true=fermeture de la boite de dialogue/false=pas de fermeture (fn facultatif))
										  })*/
    // Création de la DIV qui sert de base à la boite de dialogue 
    var index = $('.ui-dialog').size();
    var $Dlg = $(document.createElement('div'));
    $Dlg.attr('id', 'Dialog' + index)
		.addClass('Dialog');
    $().append($Dlg);


    // Prépartion des boutons
    var dlg_btns = {};
    if (Params.Type == 'Confirm') { dlg_btns['CANCEL'] = { 'text': Params.Cancel.Title, 'class': 'CANCEL', 'click': function () { if (Params.Cancel.fn != undefined) { if (Params.Cancel.fn()) { $(this).dialog('close'); } } else { $(this).dialog('close'); }; } } }
    dlg_btns['OK'] = { 'text': Params.Ok.Title, 'class': 'OK', 'click': function () { if (Params.Ok.fn != undefined) { if (Params.Ok.fn()) { $(this).dialog('close'); } } else { $(this).dialog('close'); }; } };

    // Positionnement
    Params.Position = (Params.Position == undefined) ? {} : Params.Position;
    var Position = [(Params.Position.Left == undefined) ? 'center' : Params.Position.Left, (Params.Position.Top == undefined) ? 'center' : Params.Position.Top]

    // Largeur
    Params.Width = (Params.Width == undefined) ? 448 : Params.Width;

    // Contenu du message 
    $Dlg.append(Params.Content);


    // Affichage de la boite de dialog
    $Dlg.dialog({
        dialogClass: Params.Type,
        title: Params.Title,
        buttons: dlg_btns,
        closeText: '',
        closeOnEscape: true,
        modal: true,
        resizable: false,
        minHeight: 250,
        position: Position,
        width: Params.Width,
        open: function (type, data) {
            zIndex = 11000 + index * 2;
            $('.ui-widget-overlay').css({ 'z-index': zIndex, 'height': $('#formAspNet').outerHeight() });
            $('.ui-dialog').css('z-index', zIndex + 1);
            $Dlg.find('a').blur()
                .find('button').blur()
                .find('.OK').focus();
        },
        dragStop: function (event, ui) {
            $("#dialog-modal").dialog({ position: 'center', draggable: true });
        }
    }).on('dialogclose', function (event) { $Dlg.dialog('destroy'); $Dlg.remove(); });
}

// Appels Ajax
//------------------------------
var tm_Loader;
var delay_Loader = "%DELAYLOADER%"; // délai d'apparition du Loader
function AjaxCall(P) {/*(P = {Async:true/false, 			(Facultatif (true par défaut) : Traitement synchrone(false) ou asynchrone(true))
							 Type:'html'/'script'		(Facultatif ('html' par défaut) : Indique le type de données attendues ('html' = défaut) 
							 Url:"",  					(url a appelée)
							 Data:{...},  				(Facultatif (non renseigné par défaut) : Tableau de paramètres à passer à l'url ex: {idprog:x,idmod:y})
							 Container:$(...), 			(Facultatif (non renseigné par défaut) : Si Type = 'html' permet d'insérer le contenu dans l'élément Container ex: $('#Resultat'))
							})*/
    $.ajax({
        async: (P.Async == undefined) ? true : P.Async,
        type: "POST",
        cache: false,
        url: P.Url,
        data: P.Data,
        dataType: (P.Type == undefined) ? 'html' : P.Type,
        statusCode: {
            404: function () { showMsgBox({ Type: 'Alert', Title: 'Attention', Ok: { Title: 'Ok' }, Content: 'page inconnue.' }); },
            //500: function () { showMsgBox({ Type: 'Alert', Title: 'Attention', Ok: { Title: 'Ok' }, Content: 'Erreur serveur' }); }
            500: function (xhr) { showMsgBox({ Type: 'Alert', Title: 'Attention', Ok: { Title: 'Ok' }, Content: 'Erreur serveur :<br/><br/>' + xhr.responseText }); }
        }
    })
	.done(function (content) {
	    if (P.Type == "html") {
	        if (content.indexOf('showMsgBox') != -1) {
	            eval(content);
	        } else {
	            P.Container.html(content);
	            if (P.fn != undefined) { P.fn(); }
	        }
	    } else { if (P.fn != undefined) { P.fn(); } };
	})
	.always(function (content) { clearTimeout(tm_Loader); $('#ajaxLoading').remove(); $('#ajaxLoader').remove(); });
}

// Déconnexion
//------------------------------
function Disconnect() { AjaxCall({ Type: 'script', Url: 'manageSession.aspx?idsession=00000000-0000-0000-0000-000000000000', Data: { param: 'deco' } }); }

// Page précédente
//------------------------------
function PreviousPage() { AjaxCall({ Type: 'script', Url: 'manageSession.aspx?idsession=00000000-0000-0000-0000-000000000000', Data: { param: 'previous' } }); }

// Mon compte
//------------------------------
function myAccount() { AjaxCall({ Type: 'script', Url: 'manageSession.aspx?idsession=00000000-0000-0000-0000-000000000000', Data: { param: 'account' } }); }
function myAccount_EnterEvent(e) {
    if ((e.keyCode ? e.keyCode : e.which) == 13) {
        e.stopPropagation();
        e.preventDefault();
        switch ($(this).attr('id')) {
            case "OldPWD":
                $("#NewPWD").focus();
                break;
            case "NewPWD":
                $("#ConfirmPWD").focus();
                break;
            case "ConfirmPWD":
                $(this).parent().parent().parent().find('.OK').click();
                break;
        }
    }
}

// Conditions générales d'utilisation
//------------------------------
function show_Terms() { AjaxCall({ Type: 'script', Url: 'manageSession.aspx?idsession=00000000-0000-0000-0000-000000000000', Data: { param: 'terms' } }); }

// User account menu
//------------------------------
var H_mnu = 0;
var T_mnu;

clientMnu = function (action) {
    clearTimeout(T_mnu);
    $client_mnu.stop();
    $('body').off('click');
    $('#ClientName').off('mouseleave')
					.off('mouseenter');
    if (action == 'show' && $client_mnu.hasClass('hide')) {
        if (H_mnu == 0) { $client_mnu.children().each(function () { H_mnu += $(this).outerHeight(); }) };
        $client_mnu.off('click');
        $('#ClientName').on('mouseenter', function () { clearTimeout(T_mnu); })
						.on('mouseleave', function () { T_mnu = setTimeout(function () { clientMnu('hide') }, 1500); });
        $client_mnu.removeClass('hide')
				   .animate({ height: H_mnu }, 150, function () {
				       $('body').on('click', function () { clientMnu('hide') });
				   });
    } else if (action == 'hide' && !$client_mnu.hasClass('hide')) {
        $client_mnu.animate({ height: 0 }, 150, function () { $client_mnu.addClass('hide'); $client_mnu.on('click', function () { clientMnu('show') }); });
    }
    return false;
}

// Pagination
//------------------------------
set_Pagination = function (P) {/*(P = {Page:currentPage,totalItems:...,pagingSize:...,paramsUrl:{idtopic:currentTopic,type:get_Type(),lvl:get_Level()}}
*/
    $topPagination.addClass('Pagination')
			      .html('');
    totalPage = Math.ceil(P.totalItems / P.pagingSize);
    var _params = $.param(P.paramsUrl);
    if (totalPage > 1) {
        if (P.Page != 1) { $topPagination.append('<a class="PPrev" href="' + currentUrl + '?' + _params + '&p=' + (P.Page - 1) + '" onclick="return false;" onmousedown="return load_Page({Page:' + (P.Page - 1) + '});">' + lngPrev + '</a>') }
        if (totalPage <= 8) {
            for (var i = 1; i <= totalPage; i++) {
                $topPagination.append('<a href="' + currentUrl + '?' + _params + '&p=' + i + '" onclick="return false;" onmousedown="return load_Page({Page:' + i + '});" ' + ((i == P.Page) ? 'class="PCurrent"' : '') + '>' + i + '</a>');
            }
        } else {
            if (P.Page <= 5) {
                for (var i = 1; i <= 5; i++) {
                    $topPagination.append('<a href="' + currentUrl + '?' + _params + '&p=' + i + '" onclick="return false;" onmousedown="return load_Page({Page:' + i + '});" ' + ((i == P.Page) ? 'class="PCurrent"' : '') + '>' + i + '</a>');
                }
                $topPagination.append('<a href="' + currentUrl + '?' + _params + '&p=7" onclick="return false;" onmousedown="return load_Page({Page:7});">...</a>')
							  .append('<a href="' + currentUrl + '?' + _params + '&p=' + totalPage + '" onclick="return false;" onmousedown="return load_Page({Page:' + totalPage + '});">' + totalPage + '</a>');
            } else if (P.Page >= (totalPage - 4)) {
                $topPagination.append('<a href="' + currentUrl + '?' + _params + '&p=1" onclick="return false;" onmousedown="return load_Page({Page:1});">1</a>')
							  .append('<a href="' + currentUrl + '?' + _params + '&p=' + (totalPage - 6) + '" onclick="return false;" onmousedown="return load_Page({Page:' + (totalPage - 6) + '});">...</a>');
                for (var i = (totalPage - 4) ; i <= totalPage; i++) {
                    $topPagination.append('<a href="' + currentUrl + '?' + _params + '&p=' + i + '" onclick="return false;" onmousedown="return load_Page({Page:' + i + '});" ' + ((i == P.Page) ? 'class="PCurrent"' : '') + '>' + i + '</a>');
                }
            } else {
                $topPagination.append('<a href="' + currentUrl + '?' + _params + '&p=1" onclick="return false;" onmousedown="return load_Page({Page:1});">1</a>')
							   .append('<a href="' + currentUrl + '?' + _params + '&p=' + (P.Page - 3) + '" onclick="return false;" onmousedown="return load_Page({Page:' + (P.Page - 3) + '});"">...</a>')
							   .append('<a href="' + currentUrl + '?' + _params + '&p=' + (P.Page - 1) + '" onclick="return false;" onmousedown="return load_Page({Page:' + (P.Page - 1) + '});">' + (P.Page - 1) + '</a>')
							   .append('<a href="' + currentUrl + '?' + _params + '&p=' + P.Page + '" onclick="return false;" onmousedown="return load_Page({Page:' + P.Page + '});" class="PCurrent">' + P.Page + '</a>')
							   .append('<a href="' + currentUrl + '?' + _params + '&p=' + (P.Page + 1) + '" onclick="return false;" onmousedown="return load_Page({Page:' + (P.Page + 1) + '});">' + (P.Page + 1) + '</a>')
							   .append('<a href="' + currentUrl + '?' + _params + '&p=' + (P.Page + 3) + '" onclick="return false;" onmousedown="return load_Page({Page:' + (P.Page + 3) + '});">...</a>')
							   .append('<a href="' + currentUrl + '?' + _params + '&p=' + totalPage + '" onclick="return false;" onmousedown="return load_Page({Page:' + totalPage + '});">' + totalPage + '</a>');
            }
        }
        if (P.Page != totalPage) { $topPagination.append('<a class="PNext" href="' + currentUrl + '?' + _params + '&p=' + (P.Page + 1) + '" onclick="return false;" onmousedown="return load_Page({Page:' + (P.Page + 1) + '});">' + lngNext + '</a>'); }
    }
    $bottomPagination.addClass($topPagination.attr('class'))
					 .html($topPagination.html());

    // Gestion du "pas" de pagination (nombre d'éléments par page)
    if (!$pagingSize.size() == 0) {
        $pagingSize_parent = $pagingSize.parent();
        $pagingSize_lbl = $pagingSize_parent.next();

        $pagingSize_parent.css('visibility', 'visible');
        $pagingSize_lbl.css('visibility', 'visible');

        var iSelected = -1;
        var lstItems = $pagingSize_parent.children('.options').children('li');
        lstItems.removeClass('selected hide');
        var cpt = lstItems.size();
        lstItems.each(function () {
            $Step = $(this);
            $Step_prev = $Step.prev();
            prevVal = ($Step_prev.size() > 0) ? Number($Step.prev().text()) : 0;
            currentVal = Number($Step.text());
            if (!((P.totalItems > currentVal) || (P.totalItems > prevVal && P.totalItems <= currentVal))) { $Step.addClass('hide'); cpt--; }
            if (iSelected == -1) {
                if ((currentVal >= P.totalItems) || (currentVal == P.pagingSize)) {
                    iSelected = $Step.index();
                    $Step.addClass('selected');
                    $pagingSize.children('option')[iSelected].selected = true;
                    $pagingSize_parent.children('div.styledSelect').text(currentVal);
                }
            }
        });
        // on masque la combo de choix du "pas" de pagination si un seul choix possible
        if (cpt <= 1) {
            $pagingSize_parent.css('visibility', 'hidden');
            $pagingSize_lbl.css('visibility', 'hidden');
        }
    }
}

// Gestion des favoris
//------------------------------
set_Bookmark = function () {
    if (id_client) {
        $E = $(this);
        AjaxCall({ Async: true, Type: 'script', Url: 'manageSession.aspx?idsession=00000000-0000-0000-0000-000000000000', Data: { param: 'movebookmark', idR: $E.attr('data-id'), isBookmark: $E.hasClass('Bookmarked') }, fn: function () { $('body').trigger({ type: 'onBookmarkChange', Element: $E }); } });
    }
}
add_BookmarkToDOM = function ($E) {
    if (id_client) {
        isBookmarhed = $E.hasClass('Bookmarked');
        sTitle = (isBookmarhed) ? lngBookmarks : lngAddToBookmarks;
        if ($E.is("input")) {
            $E.attr('title', (isBookmarhed) ? lngBookmarks : lngAddToBookmarks);
        } else {
            $Bookmark = $('<img class="Bookmark" src=""/>');
            $Bookmark.attr({
                'src': (isBookmarhed) ? "styles/default/images/ico_Bookmark_on.png" : "styles/default/images/ico_Bookmark_off.png",
                'alt':sTitle,
                'title':sTitle})
			    .click(function () { set_Bookmark.call($(this).parent()); return false; });
            $E.append($Bookmark);
        }
    }
}
id_client = function () { return isNaN($('meta[property="eni:client_id"]').attr("content")) }();


// Personnalisation des combos (select)
//-------------------------------------
stylize_Combo = function ($Selects) {
    $Selects.each(function () {
        $this = $(this);
        // On masque le select
        $this.addClass('s-hidden');
        // On crée l'ossature html qui remplace l'affichage du select
        $this.wrap('<div id="select_' + $this.attr('id') + '" class="select"></div>')
			 .after('<div class="styledSelect"></div>');
        var $styledSelect = $this.next('div.styledSelect');
        // On affiche l'option actuellement selectionnée
        $styledSelect.text($this.children('option:selected').text());

        // Insertion des options en forme de liste ul li
        var $list = $('<ul />', {
            'class': 'options'
        }).insertAfter($styledSelect);
        // Récupération du nombre d'élément du select
        $Opts = $this.children('option')
        nbOptions = $Opts.length;
        for (var i = 0; i < nbOptions; i++) {
            $('<li />', {
                'text': $Opts.eq(i).text(),
                'rel': $Opts.eq(i).val(),
                'class': (this.selectedIndex == i) ? 'selected' : ''
            }).appendTo($list);
        }

        // Gestion de la selection d'une nouvelle option
        var $listItems = $list.children('li');
        $styledSelect.click(function (e) {
            e.stopPropagation();
            $('div.styledSelect.active').each(function () {
                $(this).removeClass('active').next('ul.options').hide();
            });
            $(this).toggleClass('active').next('ul.options').toggle();
        });
        $listItems.click(function (e) {
            e.stopPropagation();
            $LI = $(this);
            $SELECT = $LI.parent().parent().children('select');
            $LI.parent().children('li').removeClass();
            $LI.addClass("selected");
            $styledSelect.text($LI.text()).removeClass('active');
            $SELECT.children('option').get($LI.index()).selected = true;
            $SELECT.change();
            $list.hide();
        });

        // Ferme la combo lorsqu'on clique à l'extérieur de la zone
        $(document).click(function () {
            $styledSelect.removeClass('active');
            $list.hide();
        });
    });
};
activate_inputs_Combo = function (P) {/*(P={Id:IdCombo,inputs:[0,1,...]}*/
    $lstInputs = $('#select_' + P.Id);
    $lstInputs.find('ul > li').each(function () { $(this).css('display', 'none'); });
    $.each(P.inputs, function (index, value) {
        $option = $lstInputs.find('li[rel=' + value + ']');
        if (!$option.hasClass("selected")) { $option.css('display', 'block'); }
    });
};


// retour en haut de la page
returnTop = function () { $('html,body').animate({ scrollTop: 0 }, 150); };

// Ajout fonctions Jquery
(function ($) {

    $.fn.setCursorPosition = function (pos) {
        if ($(this).get(0).setSelectionRange) {
            $(this).get(0).setSelectionRange(pos, pos);
        } else if ($(this).get(0).createTextRange) {
            var range = $(this).get(0).createTextRange();
            range.collapse(true);
            range.moveEnd('character', pos);
            range.moveStart('character', pos);
            range.select();
        }
    }

    $.fn.resizeTextarea = function () { if ($(this)[0].scrollTop > 0) { $(this).height($(this).height() + 10); $(this).resizeTextarea(); } }

    $.fn.clientOpts = function () { if (!id_client) { $(this).off('click').attr({ 'disabled': 'disabled', 'title': '' }) } }

})(jQuery);

// correctif bug sous IE + viewport
(function () {
    if (navigator.userAgent.match(/tablet|phone|mobile/i) && (window.innerWidth == screen.width && window.innerHeight == screen.height)) {
        var msViewportStyle = document.createElement("style");
        msViewportStyle.appendChild(
            document.createTextNode("@-ms-viewport{width:1010px}")
        );
        document.getElementsByTagName("head")[0].appendChild(msViewportStyle);
    }
})();


// Au chargement 
$(document).ready(function () {
    $(":button").focus(function () { $(this).blur(); }); //enlève le focus lors de l'utilisation d'un bouton
    $client_mnu = $('#ClientMnu');
    $SearchEngine = $('#SearchEngine');

    $('form').unbind();

    // initialisation du moteur de recherche
    $SearchEngine.val(lngSearchDefaultText)
				 .on({
				     'click': function () { if ($(this).val() == lngSearchDefaultText) { $(this).val(''); } },
				     'focus': function () { if ($(this).val() == lngSearchDefaultText) { $(this).val(''); } },
				     'blur': function () { if ($(this).val().length == 0) { $(this).val(lngSearchDefaultText); } },
				     'keypress': function (e) { if ((e.keyCode ? e.keyCode : e.which) == 13) { e.stopPropagation(); e.preventDefault(); Search(); return false; } }
				 });
    $('#btn_SearchEngine').attr('index', 0).click(function (e) { e.stopPropagation(); Search(); });

    // Widgets
    if ($('#Widgets').size() > 0) {
        $LastAccess = $('#LastAccess')
        $LastAccess.children('h2').after(function () {
            sHtml = "";
            if ($(this).parent().hasClass('LN')) { sHtml = '<span>' + lngLN + '</span>' }
            else if ($(this).parent().hasClass('Video')) { sHtml = '<span>' + lngVideo + '</span>' }
            return sHtml;
        })
		.ellipsis();
        add_BookmarkToDOM($LastAccess);
        $('#myBookmarks').css('display', (id_client) ? 'block' : 'none');
    }

});

function goTo(url) {
    var a = document.createElement("a");
    if (!a.click) //for IE
    {
        window.location = url;
        return;
    }
    a.setAttribute('href', url);
    a.style.display = 'none';
    $("body").append(a);
    a.click();
}

//Temps passé
//-----------
function SpentTime() { AjaxCall({ Type: 'script', Url: 'manageSession.aspx?idsession=00000000-0000-0000-0000-000000000000', Data: { param: 'SpentTimeRefresh' } }); }

//SpentTime();

function addslashes(ch) {
    ch = ch.replace(/["]/g, " ");
    return ch;
}

var lngId = "1";

$(document).ready(function () {
    resizeBG();
    $(window).resize(function () { resizeBG() });
    $(".Item").hover(
    function () {
        $(this).addClass("C5_background");
        $(this).children("a").removeClass("C2_font").addClass("C4_font");
    },
    function () {
        $(this).removeClass("C5_background");
        $(this).children("a").removeClass("C4_font").addClass("C2_font");
    }
);

    $("#cboLNG").click(function (event) {
        if ($("#cboLNG").height() == 30) {
            $("#cboLNG").animate({ height: 30 * $("#cboLNG").children().length }, 200);
            $('body').one('click', function () { $("#cboLNG").animate({ height: 30 }, 200) });
        } else { $("#cboLNG").animate({ height: 30 }, 200) }

        event.stopPropagation();
    });

    if (($.url().param('user_guid') != undefined) || (($.url().param('user_login') != undefined) && ($.url().param('user_pwd') != undefined)) || ($.url().param('user_eniuid') != undefined)) {
        AjaxCall({ Type: 'script', Url: 'connect.aspx' + location.search });
    };
});

resizeBG = function () {
    $(".background").css({ 'width': '100%', 'height': '' });
    if ($(document).height() > $(".background").height()) { $(".background").css({ 'height': $(document).height(), 'width': '' }); }
}

Connect = function () {
    if ($('#Login').val().length == 0) { showMsgBox({ Type: 'Alert', Title: sMsgBox_Title_Warning, Content: sMsgBox_NoLogin, Ok: { Title: 'Ok', fn: function () { $('#Login').focus(); return true; } } }); }
    else { /*window.location = 'home.htm';*/
        if (location.search == '') {
            AjaxCall({ Type: 'script', Url: 'connect.aspx', Data: { user_login: $('#Login').val(), user_pwd: $('#Password').val(),idlng: lngId } });
        } else {
            AjaxCall({ Type: 'script', Url: 'connect.aspx' + location.search, Data: { user_login: $('#Login').val(), user_pwd: $('#Password').val(), idlng: lngId } });
        }
    }
    return false;
}

ValidForm = function (event) { if (event.keyCode == 13) { Connect(); } }

// Constantes de langue
//-----------------------------

var sMsgBox_btn_Ok = "OK"; //"Ok"
var sMsgBox_btn_Cancel = "Annuler"; //"Annuler"
var sMsgBox_Title_Error = "Attention"; //"Une exception a été générée"
var sMsgBox_Title_Warning = "Attention";

var sMsgBox_NoLogin = "Saisissez un identifiant pour pouvoir vous connecter.";
//]]>
</script>

<div class="aspNetHidden">

	<input type="hidden" name="__EVENTVALIDATION" id="__EVENTVALIDATION" value="ESXPGRAmS9sji+xd5YR5NshOzvhjTlMLxXhV73F15SM44hC4flp8LPZU//SfJy2ltF77TWQ0R4lrdQKLYyW909opEtukA/DV3ONGkN5jdLVUYZoqShHfRPish2iFzUL1QmfGVwXksqFEn9LVjdIS0jGLAzwKfaN7HgLVjD6IJ/k=" />
</div>

            
	        <div id="frm_Connection" class="frm_Connection">
		        
                
                <img id="logo_eni" src="styles/default/images/logo_eni.gif" alt="Editions ENI" />
		
		        <ul id="cboLNG" class="C4_background hide"><li class="Current C2_font">Français</li>
                <li class="Item"><a href='login.aspx?cfgbdd=LIVRES_GRATUITS&cfgsite=Default&idlng=3' class='LNG_2 C2_font'>English</a></li><li class="Item"><a href='login.aspx?cfgbdd=LIVRES_GRATUITS&cfgsite=Default&idlng=4' class='LNG_3 C2_font'>Nederlands</a></li><li class="Item"><a href='login.aspx?cfgbdd=LIVRES_GRATUITS&cfgsite=Default&idlng=6' class='LNG_4 C2_font'>Español</a></li><li class="Item"><a href='login.aspx?cfgbdd=LIVRES_GRATUITS&cfgsite=Default&idlng=8' class='LNG_5 C2_font'>Deutsch</a></li></ul>
		
		        <p class="Description C1_font">Pour vous connecter, merci de vous identifier.</p>
		
		        <label class="C1_font" for="Login">Identifiant :</label><input name="Login" type="text" id="Login" class="C1_border" onkeypress="javascript:ValidForm(event);" />
		
		        <label class="C1_font" for="Password">Mot de passe :</label><input name="Password" type="Password" id="Password" class="C1_border" onkeypress="javascript:ValidForm(event);" />
		
		        <input name="btnLogin" type="button" id="btnLogin" class="C1_background C2_font" value="Se connecter" onclick="Connect();" />
                
		        <em class="C4_font"><span id="ltlInfosLogin">Nous vous rappelons que l'identifiant qui vous a été communiqué n'est valable que pour <b>un seul utilisateur identifié et n'est pas cessible</b>.</span></em>
	        </div>
        	
	</form>

</body>
</html>
