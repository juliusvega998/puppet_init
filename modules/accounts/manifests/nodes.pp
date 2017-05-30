node default {
	include accounts
	realize (Accounts::Virtual['monitor'])
}

node 'bpx.server.local' {
	include accounts	
	realize (Accounts::Virtual['monitor'])
}

