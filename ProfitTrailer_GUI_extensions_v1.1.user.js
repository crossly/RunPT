// ==UserScript==
// @name         ProfitTrailer GUI extensions
// @namespace    PTHelper
// @version      1.1
// @description  ProfitTrailer GUI extensions script, written for https://web.telegram.org/#/im?p=@profittrailernl
// @author       Stek
// @match        http://35.229.62.238/monitoring
// @grant        none
//
// Scripted for PT VERSION: 1.2.6.6
//
// Features:
// - Adds currency selector to top right of the window
// - Displays FIAT values in result tables, summaries and the page header
// - Adds SOMO buttons to the 'Config' menu
//
// Installation:
// - Install TamperMonkey for Chrome
// - Add this script using the TamperMonkey dashboard
// - Change the '@match' above so it matches your domain (add multiple @match tags for multiple bot pages)
// - Refresh ProfitTrailer page
//
// Buy my bot a beer (don't get him too drunk):
// - Bitcoin:  1G1sgZcxsXjaC1PV1Du9VndshNKZNTZ7y6
// - Litecoin: LWDpMqDBUpbkb4Ku8h4egSqemYmJSQfEx5
// - Ethereum: 0x3cc1e1d87a144d47ddb86969495dbbf5e0b10ca9
// - Ripple  : rPVMhWBsfF9iMXYj3aAzJVkPDTFNSyWdKy (tag: 1984127824)
//
// ==/UserScript==

(function() {
    'use strict';

    var selectedCurrency = 'USD';
    var selectedCurrencyRate = 1;
    var currencySymbol = {
        EUR: "€",
        USD: "$",
        GBP: "£",
        AUD: "$",
        BGN: "лв",
        BRL: "R$",
        CAD: "$",
        CHF: "CHF",
        CNY: "¥",
        CZK: "Kč",
        DKK: "kr",
        HKD: "$",
        HRK: "kn",
        HUF: "Ft",
        IDR: "Rp",
        ILS: "₪",
        INR: "INR",
        JPY: "¥",
        KRW: "₩",
        MXN: "$",
        MYR: "RM",
        NOK: "kr",
        NZD: "$",
        PHP: "₱",
        PLN: "zł",
        RON: "lei",
        RUB: "₽",
        SEK: "kr",
        SGD: "$",
        THB: "฿",
        TRY: "TRY",
        ZAR: "R"
        };

    $( document ).ready(function() {
        console.log( "Loaded ProfitTrailer GUI extensions v1.0" );
        addCurrencySelector();
        addSOMOButtons();

        addGlobalStyle('.dataTable td { height: 44px !important; }');
        addGlobalStyle('#currencySelector {color: #98a6ad; background-color: #323b44; border-color: #98a6ad;}');

        doPoll();
    });

    function addCurrencySelector() {
        if ($('#currencySelector').length === 0) {
            $.getJSON( "https://api.fixer.io/latest?base=USD", function( data ) {
                var items = "<option value='1'>USD</option>" ;
                $.each( data.rates, function( key, val ) {
                    var selected = key === readCookie('PT_SELECTED_CURRENCY') ? 'selected' : '';
                    items += "<option value='" + val + "' " + selected + ">" + key + "</option>" ;
                });

                $('#dvCurrentUTCTime').after('<span><label class=" hide-phone"><span class="full-text">Currency: </span></label>&nbsp;<select id="currencySelector" name="currencySelector">' + items + '</select></span>');

                $( "#currencySelector" ).change(function () {
                    selectedCurrency = $('#currencySelector option:selected').text();
                    selectedCurrencyRate =  $('#currencySelector option:selected').val();
                    console.log('Setting currency to ' + selectedCurrency + ' with usd rate of ' + selectedCurrencyRate);
                    createCookie('PT_SELECTED_CURRENCY', selectedCurrency, 999);

                });
                $( "#currencySelector" ).trigger("change");
                console.log( "Added currency selector" );
            });
        }
    }

    function appendFiatValue(element, btcUsdPrice, newLine, parentheses) {
        appendFiatValueByBtcAmount(element, btcUsdPrice, newLine, parentheses, $(element).text());
    }

    function appendFiatValueByBtcAmount(element, btcUsdPrice, newLine, parentheses, btcValue) {
        if ($(element).find('.fiatValue').length === 0) {
            $(element).append((newLine ? '<br>' : '') + '<span class="fiatValue">' + (parentheses ? ' (' : '') + convertBTCToFiatString(btcValue, btcUsdPrice) + (parentheses ? ')' : '') + '</span>');
        }
    }

    function convertBTCToFiatString(btcValue, btcUsdPrice) {
        return currencySymbol[selectedCurrency] + (Math.round(btcValue * btcUsdPrice * 100 * selectedCurrencyRate) / 100).toFixed(2);
    }

    function doPoll() {
        var pollTime = 100;
        var btcUsdPrice = $('#nMarketPrice').text();

        // Page header
        $('#nBalanceVal, #nTotalCurrentVal, #nTotalPendingVal').each(function(){
            appendFiatValue(this, btcUsdPrice, false, true);
        });

        // Pair log - table fields
        $('#dtPairsLogs td.bought-price, #dtPairsLogs td.current-price, #dtPairsLogs td.current-value, #dtPairsLogs td.bought-cost').each(function(){
            appendFiatValue(this, btcUsdPrice, true, false);
        });

        // Pair log - summary fields
        $('.summary-table td#pairsLogTotalCurrentVal, .summary-table #pairsLogDifference .value, .summary-table td#pairsLogRealCost, .summary-table #dcLogTotalCurrentVal, dcLogDifference').each(function(){
            appendFiatValue(this, btcUsdPrice, true, false);
        });

        // Sales log - table fields
        $('#dtSalesLog td.sold-price, #dtSalesLog td.profit-btc>span:first-child, #dtSalesLog td.bought-cost, #dtSalesLog td.sold-value').each(function(){
            appendFiatValue(this, btcUsdPrice, true, false);
        });

        // Sales log - summary fields
        $('.summary-table #salesLogBoughtCost, .summary-table #salesLogDifference .value, .summary-table #salesLogTotalCurrentVal').each(function(){
            appendFiatValue(this, btcUsdPrice, true, false);
        });

        // Sales log - Remove default dollar value
        $('#dtSalesLog .sales-market-profit').hide();

        // Dust log - table fields
        $('#dtDustLogs td.current-price, #dtDustLogs td.current-value, #dtDustLogs td.bought-cost').each(function(){
            appendFiatValue(this, btcUsdPrice, true, false);
        });

        // Sales log - summary fields
        $('.summary-table #dustLogTotalCurrentVal, .summary-table #dustLogDifference .value, .summary-table #dustLogRealCost').each(function(){
            appendFiatValue(this, btcUsdPrice, true, false);
        });

        // DCA log - table bought price field
        $('#dtSalesLog .bought-price').each(function(){
            var rawValue = $(this).text();
            var btcAmount = rawValue.substring(0, rawValue.indexOf('('));
            appendFiatValueByBtcAmount(this, btcUsdPrice, true, false, btcAmount);
        });

        // DCA log - table current price / average price field
        $('#dtDcaLogs .dca-avg-current-price').each(function(){
            if (!$(this).hasClass('fiatValue')){
                $(this).addClass('fiatValue');
                var btcAmounts = $(this).clone().children().remove('span').end().html().split('<br>');
                $(this).find('.dca-bought-times:eq(0)').after('<br>' + convertBTCToFiatString(btcAmounts[0], btcUsdPrice) + '<span class="dca-bought-times invisible">' + $(this).find('.dca-bought-times:eq(0)').text() + '</span>');
                $(this).find('.dca-bought-times:eq(2)').after('<br>' + convertBTCToFiatString(btcAmounts[1], btcUsdPrice) + '<span class="dca-bought-times invisible">' + $(this).find('.dca-bought-times:eq(2)').text() + '</span>');
            }
        });

        // DCA log - table current value / total costs field
        $('#dtDcaLogs td.current-value').each(function(){
            if (!$(this).hasClass('fiatValue')){
                $(this).addClass('fiatValue');
                var btcAmounts = $(this).html().split('<br>');
                $(this).html(btcAmounts[0] + '<br>' + convertBTCToFiatString(btcAmounts[0], btcUsdPrice) + '<br>' + btcAmounts[1] + '<br>' +  convertBTCToFiatString(btcAmounts[1], btcUsdPrice));
            }
        });

         // DCA log - summary fields
        $('.summary-table #dcLogTotalCurrentVal, .summary-table #dcLogDifference .value, .summary-table #dcLogRealCost').each(function(){
            appendFiatValue(this, btcUsdPrice, true, false);
        });

        setTimeout(doPoll,pollTime);
    }

    function addSOMOButtons() {
        var somOn = document.createElement("li");
        var somOff = document.createElement("li");
        var somoOn = document.createElement("li");
        var somoReset = document.createElement("li");
        somOn.innerHTML = "<a href=" + '"' + "/settings/sellOnlyMode?type=&enabled=true"  + '"' + "class=" + '"' + "waves-effect waves-primary" + '"' + "><i class=" + '"' + "fa fa-check-circle-o" + '"' + "></i><span> Sell Only Mode On</span></a>";
        somOff.innerHTML = "<a href=" + '"' + "settings/sellOnlyMode?type=&enabled=false"  + '"' + "class=" + '"' + "waves-effect waves-primary" + '"' + "><i class=" + '"' + "fa fa-times-circle-o" + '"' + "></i><span> Sell Only Mode Off </span></a>";
        somoOn.innerHTML = "<a href=" + '"' + "settings/overrideSellOnlyMode?enabled=false"  + '"' + "class=" + '"' + "waves-effect waves-primary" + '"' + "><i class=" + '"' + "fa fa-ban" + '"' + "></i><span> Override SOM </span></a>";
        somoReset.innerHTML = "<a href=" + '"' + "/settings/overrideSellOnlyMode"  + '"' + "class=" + '"' + "waves-effect waves-primary" + '"' + "><i class=" + '"' + "fa fa-refresh" + '"' + "></i><span> Reset SOM </span></a>";
        var sideMenu = document.getElementsByTagName("ul")[4];
        sideMenu.appendChild(somOn);
        sideMenu.appendChild(somOff);
        sideMenu.appendChild(somoOn);
        sideMenu.appendChild(somoReset);
        console.log("Added SOMO buttons");
    }

    function createCookie(name, value, days) {
        var expires;

        if (days) {
            var date = new Date();
            date.setTime(date.getTime() + (days * 24 * 60 * 60 * 1000));
            expires = "; expires=" + date.toGMTString();
        } else {
            expires = "";
        }
        document.cookie = encodeURIComponent(name) + "=" + encodeURIComponent(value) + expires + "; path=/";
    }

    function readCookie(name) {
        var nameEQ = encodeURIComponent(name) + "=";
        var ca = document.cookie.split(';');
        for (var i = 0; i < ca.length; i++) {
            var c = ca[i];
            while (c.charAt(0) === ' ') c = c.substring(1, c.length);
            if (c.indexOf(nameEQ) === 0) return decodeURIComponent(c.substring(nameEQ.length, c.length));
        }
        return null;
    }

    function addGlobalStyle(css) {
        var head, style;
        head = document.getElementsByTagName('head')[0];
        if (!head) { return; }
        style = document.createElement('style');
        style.type = 'text/css';
        style.innerHTML = css;
        head.appendChild(style);
    }
})();