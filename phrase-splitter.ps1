# powershell
# type .\input.txt | .\phrase-splitter.ps1 > output.txt

Write-Host "Loading dictionary, this may take a while..."

$dictionary = Get-Content dictionary.txt

# noise words are removed from entries before parsing
$noise = @("_", "-")

# prefix noise words are only removed from the start of entries
$prefix = @("cp", "au", "dre", "autn", "var")

$words = $input.Split()

for($i = 0; $i -lt $words.Count; $i++)
{
	$current_word = $words[$i]

	for($j = 0; $j -lt $noise.Length; $j++) {
		$current_word = $current_word.Replace($noise[$j], "")
	}

	for($j = 0; $j -lt $prefix.Length; $j++) {
		$prefix_word = $prefix[$j]

		if($current_word.ToLower().StartsWith($prefix_word)) {
			$current_word = $current_word.SubString($prefix_word.Length)
		}
	}

	$pretty_word = ""
	$start = 0
	$finish = $current_word.Length
	$done = $false

	while($finish -gt $start) {
		for($k = 0; $k -lt $dictionary.Count; $k++) {
			$dictionary_word = $dictionary[$k]
			$subword = $current_word.Substring($start, $finish - $start)

			if($subword -eq $dictionary_word) {
				$pretty_word += $dictionary_word.Substring(0, 1).ToUpper() + $dictionary_word.Substring(1) + " "
				$start = $finish
				$finish = $current_word.Length
				$k = -1

				if($start -ge $current_word.Length) {
					$done = $true
					break
				}
			}
		}

		if($done -eq $true) {
			break
		}

		$finish--;
	}

	$trimmed = $pretty_word.Trim()

	$trimmed
}