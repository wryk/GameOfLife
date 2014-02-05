sub clear {
	$*OS eq 'MSWin32' ?? 'cls' !! 'clear'
	==> shell;
}

class Life {
	has @.grid;
	has Int $.dim;

	multi method new(@grid) {
		Life.bless(dim => @grid.elems, grid => @grid);
	}

	multi method new(Int $dim) {
		Life.new([[True, False].roll($dim)] xx $dim);
	}

	method tick {
		my $prev = self.clone;
		for ^$.dim X ^$.dim -> $y, $x {
			my $neigh = [+] map({ $prev.alive($^y, $^x); }, ($y - 1, $y, $y + 1 X $x - 1, $x, $x + 1)), -$prev.alive($y, $x);
			@.grid[$y][$x] = do given $prev.alive($y, $x) {
				when 0 { $neigh ~~ 2 | 3 } # currently dead
				when 1 { $neigh ~~ 3     } # currently alive
			}
		}
	}

	method alive(Int $y, Int $x) returns Bool {
		0 <= $y <= $.dim && 0 <= $x <= $.dim && @.grid[$y][$x] // False;
	}

	method Str { @.grid.map(*.map({$^v ?? "+" !! " "}).join).join("\n") }

	method clone {
		Life.new(map({ [$^row.clone] }, @.grid));
	}
}

my Life $life .= new(8);

loop {
	clear;
	say ~$life;
	$life.tick;
}
