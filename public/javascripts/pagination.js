function Pager(tableName, itemsPerPage, pagerName, positionId) {
this.tableName = tableName;
this.itemsPerPage = itemsPerPage;
this.pagerName = pagerName;
this.positionId = positionId;
this.currentPage = 1;
this.pages = 0;
this.inited = false;
this.numbers = new Array(10);

this.showRecords = function (from, to) {
    var table = document.getElementById(tableName);
    var rows = table.rows;

    from--; to--; // converting 'from' and 'to' as array indices

    for (var i = 0; i < rows.length; i++) {
        if (i < from || i > to) rows[i].style.display = 'none';
        else rows[i].style.display = '';
    }
}
this.showPage = function (pageNumber) {
    if (!this.inited) {
        alert("not inited");
        return;
    }
    if (this.isRedrawNeeded(pageNumber)) {
        var startPage = Math.floor((pageNumber - 1) * 0.1) * 10;
        this.showPageNav(startPage + 1);
    }
    var oldPageAnchor = document.getElementById(this.pagerName + 'pg' + this.currentPage);
    if (oldPageAnchor != null) {
        oldPageAnchor.className = '';
    }
    this.currentPage = pageNumber;
    var newPageAnchor = document.getElementById(this.pagerName + 'pg' + this.currentPage);
    if (newPageAnchor != null) {
        newPageAnchor.className = 'active';
    }
    var from = (pageNumber - 1) * itemsPerPage + 1;
    var to = from + itemsPerPage - 1;
    this.showRecords(from, to);

    var pgNext = document.getElementById('next_page');
    var pgPrev = document.getElementById('previous_page');

    if (pgNext != null) {
        if (this.currentPage == this.pages) pgNext.style.display = 'none';
        else pgNext.style.display = '';
    }
    if (pgPrev != null) {
        if (this.currentPage == 1) pgPrev.style.display = 'none';
        else pgPrev.style.display = '';
    }

    // disabling the prev and next links
    var prevLink = document.querySelector(".previous_page"),
        nextLink = document.querySelector(".next_page");

    if(prevLink != null) {
      prevLink.className = prevLink.className.replace(/ ?disabled ?/, "");
      if (this.currentPage == 1) {
          prevLink.className += " disabled";
      }
    }
    if(nextLink != null) {
      nextLink.className = nextLink.className.replace(/ ?disabled ?/, "");
      if (this.currentPage == this.pages) {
        nextLink.className += " disabled";
      }
    }

}
this.prev = function () {
    if (this.currentPage > 1) this.showPage(this.currentPage - 1);
}
this.next = function () {
    if (this.currentPage < this.pages) {
        this.showPage(this.currentPage + 1);
    }
}
this.init = function () {
    var rows = document.getElementById(tableName).rows;
    var records = rows.length;
    this.pages = Math.ceil(records / itemsPerPage);
    this.inited = true;
}
this.isRedrawNeeded = function (pageNumber) {

    for (var i = 0; i < this.numbers.length; i++) {
        if (this.numbers[i] == pageNumber) {
            return false;
        }
    }
    return true;
}
this.showPageNav = function (start) {
        if (!this.inited) {
            alert("not inited");
            return;
        }
        var element = document.getElementById(this.positionId);
        var loopEnd = start + 9;
        var index = 0;
        this.numbers = new Array(10);

        var pagerHtml = '<ul>';
        if (this.pages > 1) {
            pagerHtml += '<li>'
            pagerHtml += '<a class="prev previous_page" onclick="' + this.pagerName + '.prev();" class="">← Prev</a></li>';
        }
        for (var page = start; page <= loopEnd; page++) {
            if (page > this.pages) {
                break;
            }
            this.numbers[index] = page;
            pagerHtml += '<li>';
            pagerHtml += '<a id="' + this.pagerName + 'pg' + page + '" class="" onclick="' + this.pagerName + '.showPage(' + page + ');">' + page + '</a></li>';
            if (page != loopEnd) {
                pagerHtml += '   ';
            }
            index++;
        }
        page--;
        /*if (this.pages > page) {
            pagerHtml += '<li class="regularDataBlue">...</li>';
        }*/
        pagerHtml += '<li>';
        pagerHtml += '<a class="next next_page" onclick="' + this.pagerName + '.next();" class="">Next →</a></li>';
        element.innerHTML = pagerHtml;
    }
}
