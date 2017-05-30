node default {
}

node 'bpx.server.local' {
	include accounts	
	realize (Accounts::Virtual['johndoe'])
}

