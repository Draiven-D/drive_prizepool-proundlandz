const Config = new Object();
Config.closeKeys = [113, 27];

const vue = new Vue({
	el: '#main',
	data: {
		hasViewer: false,
		Config: [],
		AData: [],
		myPool: 0,
		myTicket: 0,
		noteViewer: false,
		description: []
	},
	methods: {
		SendTicket() {
            $.post("http://drive_prizepool/SendTicket", JSON.stringify({}));
        },
		ShowNote() {
			if (!this.noteViewer) {
				this.noteViewer = true;
			} else {
				this.noteViewer = false;
			}
		},
		CheckLimit(x) {
			let num = x
			if (num > this.Config.Limit) {
				num = this.Config.Limit
			}
			return num;
		},
		numberWithCommas(x) {
			return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
		}
	}
});

window.addEventListener('message', (event) => {
	var event = event.data;
	if (event.message == 'openUI') {
		vue.hasViewer = true;
		vue.noteViewer = false;
	} else if (event.message == 'closeUI') {
		vue.hasViewer = false;
		vue.noteViewer = false;
	} else if (event.message == 'SetData') {
		vue.Config = event.cf;
		vue.AData = event.alldata;
		vue.myPool = event.mypool;
		vue.myTicket = event.myticket;
		vue.description = event.description;
	} else if (event.message == 'UpdateData') {
		vue.AData = event.alldata;
		vue.myPool = event.mypool;
		vue.myTicket = event.myticket;
	}
});

$("body").on("keyup", function (key) {
	if (Config.closeKeys.includes(key.which)) {
		if (vue.noteViewer) {
			vue.noteViewer = false;
		} else {
			$.post('http://drive_prizepool/closeUI', JSON.stringify({}));
		}
	}
});
