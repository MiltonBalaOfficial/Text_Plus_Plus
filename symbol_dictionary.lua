-- The dictionary for texts
-- If you need extra texts, just add the Category and texts (unicode)  in the dictionary
local symbolDictionary = {
    [1] = {
        category = "Greek Small Letters",
        texts = {
            [1] = { dialogText = "α", textSymbol = "α" }, -- Alpha
            [2] = { dialogText = "β", textSymbol = "β" }, -- Beta
            [3] = { dialogText = "γ", textSymbol = "γ" }, -- Gamma
            [4] = { dialogText = "δ", textSymbol = "δ" }, -- Delta
            [5] = { dialogText = "ε", textSymbol = "ε" }, -- Epsilon
            [6] = { dialogText = "ζ", textSymbol = "ζ" }, -- Zeta
            [7] = { dialogText = "η", textSymbol = "η" }, -- Eta
            [8] = { dialogText = "θ", textSymbol = "θ" }, -- Theta
            [9] = { dialogText = "ι", textSymbol = "ι" }, -- Iota
            [10] = { dialogText = "κ", textSymbol = "κ" }, -- Kappa
            [11] = { dialogText = "λ", textSymbol = "λ" }, -- Lambda
            [12] = { dialogText = "μ", textSymbol = "μ" }, -- Mu
            [13] = { dialogText = "ν", textSymbol = "ν" }, -- Nu
            [14] = { dialogText = "ξ", textSymbol = "ξ" }, -- Xi
            [15] = { dialogText = "ο", textSymbol = "ο" }, -- Omicron
            [16] = { dialogText = "π", textSymbol = "π" }, -- Pi
            [17] = { dialogText = "ρ", textSymbol = "ρ" }, -- Rho
            [18] = { dialogText = "σ", textSymbol = "σ" }, -- Sigma
            [19] = { dialogText = "ς", textSymbol = "ς" }, -- Final Sigma
            [20] = { dialogText = "τ", textSymbol = "τ" }, -- Tau
            [21] = { dialogText = "υ", textSymbol = "υ" }, -- Upsilon
            [22] = { dialogText = "φ", textSymbol = "φ" }, -- Phi
            [23] = { dialogText = "χ", textSymbol = "χ" }, -- Chi
            [24] = { dialogText = "ψ", textSymbol = "ψ" }, -- Psi
            [25] = { dialogText = "ω", textSymbol = "ω" }, -- Omega
        },            
    },
    [2] = {
        category = "Greek Capital Letters",
        texts = {
            [1] = { dialogText = "Α", textSymbol = "Α" }, -- Alpha
            [2] = { dialogText = "Β", textSymbol = "Β" }, -- Beta
            [3] = { dialogText = "Γ", textSymbol = "Γ" }, -- Gamma
            [4] = { dialogText = "Δ", textSymbol = "Δ" }, -- Delta
            [5] = { dialogText = "Ε", textSymbol = "Ε" }, -- Epsilon
            [6] = { dialogText = "Ζ", textSymbol = "Ζ" }, -- Zeta
            [7] = { dialogText = "Η", textSymbol = "Η" }, -- Eta
            [8] = { dialogText = "Θ", textSymbol = "Θ" }, -- Theta
            [9] = { dialogText = "Ι", textSymbol = "Ι" }, -- Iota
            [10] = { dialogText = "Κ", textSymbol = "Κ" }, -- Kappa
            [11] = { dialogText = "Λ", textSymbol = "Λ" }, -- Lambda
            [12] = { dialogText = "Μ", textSymbol = "Μ" }, -- Mu
            [13] = { dialogText = "Ν", textSymbol = "Ν" }, -- Nu
            [14] = { dialogText = "Ξ", textSymbol = "Ξ" }, -- Xi
            [15] = { dialogText = "Ο", textSymbol = "Ο" }, -- Omicron
            [16] = { dialogText = "Π", textSymbol = "Π" }, -- Pi
            [17] = { dialogText = "Ρ", textSymbol = "Ρ" }, -- Rho
            [18] = { dialogText = "Σ", textSymbol = "Σ" }, -- Sigma
            [19] = { dialogText = "Τ", textSymbol = "Τ" }, -- Tau
            [20] = { dialogText = "Υ", textSymbol = "Υ" }, -- Upsilon
            [21] = { dialogText = "Φ", textSymbol = "Φ" }, -- Phi
            [22] = { dialogText = "Χ", textSymbol = "Χ" }, -- Chi
            [23] = { dialogText = "Ψ", textSymbol = "Ψ" }, -- Psi
            [24] = { dialogText = "Ω", textSymbol = "Ω" }, -- Omega
        },    
    },
    [3] = {
        category = "Superscripts",
        texts = {
            -- Symbols
            [1] = { dialogText = "▢°", textSymbol = "°" }, -- Degree
            [2] = { dialogText = "▢′", textSymbol = "′" }, -- Prime
            [3] = { dialogText = "▢″", textSymbol = "″" }, -- Double Prime
            [4] = { dialogText = "▢‴", textSymbol = "‴" }, -- Triple Prime
            [5] = { dialogText = "▢⁺", textSymbol = "⁺" }, -- Superscript Plus
            [6] = { dialogText = "▢⁻", textSymbol = "⁻" }, -- Superscript Minus
            [7] = { dialogText = "▢⁼", textSymbol = "⁼" }, -- Superscript Equals
            [8] = { dialogText = "▢⁽", textSymbol = "⁽" }, -- Superscript Left Parenthesis
            [9] = { dialogText = "▢⁾", textSymbol = "⁾" }, -- Superscript Right Parenthesis
        
            -- Digits
            [10] = { dialogText = "▢⁰", textSymbol = "⁰" }, -- Superscript 0
            [11] = { dialogText = "▢¹", textSymbol = "¹" }, -- Superscript 1
            [12] = { dialogText = "▢²", textSymbol = "²" }, -- Superscript 2
            [13] = { dialogText = "▢³", textSymbol = "³" }, -- Superscript 3
            [14] = { dialogText = "▢⁴", textSymbol = "⁴" }, -- Superscript 4
            [15] = { dialogText = "▢⁵", textSymbol = "⁵" }, -- Superscript 5
            [16] = { dialogText = "▢⁶", textSymbol = "⁶" }, -- Superscript 6
            [17] = { dialogText = "▢⁷", textSymbol = "⁷" }, -- Superscript 7
            [18] = { dialogText = "▢⁸", textSymbol = "⁸" }, -- Superscript 8
            [19] = { dialogText = "▢⁹", textSymbol = "⁹" }, -- Superscript 9
        
            -- Alphabet
            [20] = { dialogText = "▢ᵃ", textSymbol = "ᵃ" }, -- Superscript 'a'
            [21] = { dialogText = "▢ᵇ", textSymbol = "ᵇ" }, -- Superscript 'b'
            [22] = { dialogText = "▢ᶜ", textSymbol = "ᶜ" }, -- Superscript 'c'
            [23] = { dialogText = "▢ᵈ", textSymbol = "ᵈ" }, -- Superscript 'd'
            [24] = { dialogText = "▢ᵉ", textSymbol = "ᵉ" }, -- Superscript 'e'
            [25] = { dialogText = "▢ᶠ", textSymbol = "ᶠ" }, -- Superscript 'f'
            [26] = { dialogText = "▢ᵍ", textSymbol = "ᵍ" }, -- Superscript 'g'
            [27] = { dialogText = "▢ʰ", textSymbol = "ʰ" }, -- Superscript 'h'
            [28] = { dialogText = "▢ᶦ", textSymbol = "ᶦ" }, -- Superscript 'i'
            [29] = { dialogText = "▢ʲ", textSymbol = "ʲ" }, -- Superscript 'j'
            [30] = { dialogText = "▢ᶫ", textSymbol = "ᶫ" }, -- Superscript 'l'
            [31] = { dialogText = "▢ᵐ", textSymbol = "ᵐ" }, -- Superscript 'm'
            [32] = { dialogText = "▢ⁿ", textSymbol = "ⁿ" }, -- Superscript 'n'
            [33] = { dialogText = "▢ᵒ", textSymbol = "ᵒ" }, -- Superscript 'o'
            [34] = { dialogText = "▢ᵖ", textSymbol = "ᵖ" }, -- Superscript 'p'
            [35] = { dialogText = "▢ʳ", textSymbol = "ʳ" }, -- Superscript 'r'
            [36] = { dialogText = "▢ˢ", textSymbol = "ˢ" }, -- Superscript 's'
            [37] = { dialogText = "▢ᵗ", textSymbol = "ᵗ" }, -- Superscript 't'
            [38] = { dialogText = "▢ᵘ", textSymbol = "ᵘ" }, -- Superscript 'u'
            [39] = { dialogText = "▢ᵛ", textSymbol = "ᵛ" }, -- Superscript 'v'
            [40] = { dialogText = "▢ʷ", textSymbol = "ʷ" }, -- Superscript 'w'
            [41] = { dialogText = "▢ˣ", textSymbol = "ˣ" }, -- Superscript 'x'
            [42] = { dialogText = "▢ʸ", textSymbol = "ʸ" }, -- Superscript 'y'
            [43] = { dialogText = "▢ᶻ", textSymbol = "ᶻ" }, -- Superscript 'z'
        },
        
    },
    [4] = {
        category = "Subscripts",
        texts = {
            -- Symbols
            [1] = { dialogText = "▢₊", textSymbol = "₊" }, -- Subscript Plus
            [2] = { dialogText = "▢₋", textSymbol = "₋" }, -- Subscript Minus
            [3] = { dialogText = "▢₌", textSymbol = "₌" }, -- Subscript Equals
            [4] = { dialogText = "▢₍", textSymbol = "₍" }, -- Subscript Left Parenthesis
            [5] = { dialogText = "▢₎", textSymbol = "₎" }, -- Subscript Right Parenthesis
        
            -- Digits
            [6] = { dialogText = "▢₀", textSymbol = "₀" }, -- Subscript 0
            [7] = { dialogText = "▢₁", textSymbol = "₁" }, -- Subscript 1
            [8] = { dialogText = "▢₂", textSymbol = "₂" }, -- Subscript 2
            [9] = { dialogText = "▢₃", textSymbol = "₃" }, -- Subscript 3
            [10] = { dialogText = "▢₄", textSymbol = "₄" }, -- Subscript 4
            [11] = { dialogText = "▢₅", textSymbol = "₅" }, -- Subscript 5
            [12] = { dialogText = "▢₆", textSymbol = "₆" }, -- Subscript 6
            [13] = { dialogText = "▢₇", textSymbol = "₇" }, -- Subscript 7
            [14] = { dialogText = "▢₈", textSymbol = "₈" }, -- Subscript 8
            [15] = { dialogText = "▢₉", textSymbol = "₉" }, -- Subscript 9
        
            -- Alphabet
            [16] = { dialogText = "▢ₐ", textSymbol = "ₐ" }, -- Subscript 'a'
            [17] = { dialogText = "▢ₑ", textSymbol = "ₑ" }, -- Subscript 'e'
            [18] = { dialogText = "▢ₕ", textSymbol = "ₕ" }, -- Subscript 'h'
            [19] = { dialogText = "▢ᵢ", textSymbol = "ᵢ" }, -- Subscript 'i'
            [20] = { dialogText = "▢ⱼ", textSymbol = "ⱼ" }, -- Subscript 'j'
            [21] = { dialogText = "▢ₖ", textSymbol = "ₖ" }, -- Subscript 'k'
            [22] = { dialogText = "▢ₗ", textSymbol = "ₗ" }, -- Subscript 'l'
            [23] = { dialogText = "▢ₘ", textSymbol = "ₘ" }, -- Subscript 'm'
            [24] = { dialogText = "▢ₙ", textSymbol = "ₙ" }, -- Subscript 'n'
            [25] = { dialogText = "▢ₒ", textSymbol = "ₒ" }, -- Subscript 'o'
            [26] = { dialogText = "▢ₚ", textSymbol = "ₚ" }, -- Subscript 'p'
            [27] = { dialogText = "▢ᵣ", textSymbol = "ᵣ" }, -- Subscript 'r'
            [28] = { dialogText = "▢ₛ", textSymbol = "ₛ" }, -- Subscript 's'
            [29] = { dialogText = "▢ₜ", textSymbol = "ₜ" }, -- Subscript 't'
            [30] = { dialogText = "▢ᵤ", textSymbol = "ᵤ" }, -- Subscript 'u'
            [31] = { dialogText = "▢ᵥ", textSymbol = "ᵥ" }, -- Subscript 'v'
            [32] = { dialogText = "▢ₓ", textSymbol = "ₓ" }, -- Subscript 'x'
            [33] = { dialogText = "▢ᵧ", textSymbol = "ᵧ" }, -- Subscript 'y'
        },       
    },
    [5] = {
        category = "Mathematical Symbols",
        texts = {
            [1] = { dialogText = "∑", textSymbol = "∑" },  -- Summation
            [2] = { dialogText = "∫", textSymbol = "∫" },  -- Integral
            [3] = { dialogText = "∛", textSymbol = "∛" },  -- Cube root
            [4] = { dialogText = "∜", textSymbol = "∜" },  -- Fourth root
            [5] = { dialogText = "√", textSymbol = "√" },  -- Square root
            [6] = { dialogText = "±", textSymbol = "±" },  -- Plus-minus
            [7] = { dialogText = "∓", textSymbol = "∓" },  -- Minus-plus
            [8] = { dialogText = "×", textSymbol = "×" },  -- Multiplication
            [9] = { dialogText = "÷", textSymbol = "÷" },  -- Division
            [10] = { dialogText = "−", textSymbol = "−" }, -- Minus (true minus sign)
            [11] = { dialogText = "+", textSymbol = "+" }, -- Plus
            [12] = { dialogText = "⋅", textSymbol = "⋅" }, -- Dot operator
            [13] = { dialogText = "≤", textSymbol = "≤" }, -- Less than or equal to
            [14] = { dialogText = "≥", textSymbol = "≥" }, -- Greater than or equal to
            [15] = { dialogText = "≈", textSymbol = "≈" }, -- Approximately equal
            [16] = { dialogText = "≠", textSymbol = "≠" }, -- Not equal to
            [17] = { dialogText = "≡", textSymbol = "≡" }, -- Identical to
            [18] = { dialogText = "⊂", textSymbol = "⊂" }, -- Subset
            [19] = { dialogText = "⊃", textSymbol = "⊃" }, -- Superset
            [20] = { dialogText = "∈", textSymbol = "∈" }, -- Element of
            [21] = { dialogText = "∉", textSymbol = "∉" }, -- Not an element of
            [22] = { dialogText = "⊄", textSymbol = "⊄" }, -- Not a subset of
            [23] = { dialogText = "∅", textSymbol = "∅" }, -- Empty set
            [24] = { dialogText = "∩", textSymbol = "∩" }, -- Intersection
            [25] = { dialogText = "∪", textSymbol = "∪" }, -- Union
            [26] = { dialogText = "⊕", textSymbol = "⊕" }, -- Direct sum
            [27] = { dialogText = "⊗", textSymbol = "⊗" }, -- Tensor product
            [28] = { dialogText = "≪", textSymbol = "≪" }, -- Much less than
            [29] = { dialogText = "≫", textSymbol = "≫" }, -- Much greater than
            [30] = { dialogText = "∂", textSymbol = "∂" }, -- Partial derivative symbol
            [31] = { dialogText = "ħ", textSymbol = "ħ" }, -- Reduced Planck's constant
            [32] = { dialogText = "∞", textSymbol = "∞" }, -- Infinity
            [33] = { dialogText = "∇", textSymbol = "∇" }, -- Nabla (del operator)
            [34] = { dialogText = "∧", textSymbol = "∧" }, -- Logical AND
            [35] = { dialogText = "∨", textSymbol = "∨" }, -- Logical OR
            [36] = { dialogText = "¬", textSymbol = "¬" }, -- NOT
            [37] = { dialogText = "∀", textSymbol = "∀" }, -- For all
            [38] = { dialogText = "∃", textSymbol = "∃" }, -- There exists
            [39] = { dialogText = "∄", textSymbol = "∄" }, -- There does not exist
            [40] = { dialogText = "∝", textSymbol = "∝" }, -- Proportional to
            [41] = { dialogText = "∴", textSymbol = "∴" }, -- Therefore
            [42] = { dialogText = "∵", textSymbol = "∵" }, -- Because
            [43] = { dialogText = "⊥", textSymbol = "⊥" }, -- Perpendicular
            [44] = { dialogText = "⋀", textSymbol = "⋀" }, -- N-ary Logical AND
            [45] = { dialogText = "⋁", textSymbol = "⋁" }, -- N-ary Logical OR
            [46] = { dialogText = "∪", textSymbol = "∪" }, -- N-ary union
        },
    },
    [6] = {
        category = "Other Symbols", 
        texts = {
            [1] = { dialogText = "◯", textSymbol = "◯" },  -- Circle (empty)
            [2] = { dialogText = "▢", textSymbol = "▢" },  -- Square (empty)
            [3] = { dialogText = "◻", textSymbol = "◻" },  -- White square
            [4] = { dialogText = "■", textSymbol = "■" },  -- Black square
            [5] = { dialogText = "⬚", textSymbol = "⬚" },  -- Diamond shape
            [6] = { dialogText = "⬭", textSymbol = "⬭" },  -- Circled dot
            [7] = { dialogText = "⚝", textSymbol = "⚝" },  -- Star symbol
            [8] = { dialogText = "★", textSymbol = "★" },  -- Star (filled)
            [9] = { dialogText = "Å", textSymbol = "Å" },  -- Angstrom (used in physics)
            [10] = { dialogText = "℃", textSymbol = "℃" }, -- Celsius symbol
            [11] = { dialogText = "℉", textSymbol = "℉" }, -- Fahrenheit symbol
            [12] = { dialogText = "¢", textSymbol = "¢" },  -- Cent symbol
            [13] = { dialogText = "€", textSymbol = "€" },  -- Euro symbol
            [14] = { dialogText = "©", textSymbol = "©" },  -- Copyright symbol
            [15] = { dialogText = "®", textSymbol = "®" },  -- Registered trademark symbol
            [16] = { dialogText = "™", textSymbol = "™" },  -- Trademark symbol
            [17] = { dialogText = "§", textSymbol = "§" },  -- Section symbol
            [18] = { dialogText = "¶", textSymbol = "¶" },  -- Paragraph symbol
            -- Arrows
            [19] = { dialogText = "→", textSymbol = "→" },  -- Right arrow
            [20] = { dialogText = "←", textSymbol = "←" },  -- Left arrow
            [21] = { dialogText = "↑", textSymbol = "↑" },  -- Up arrow
            [22] = { dialogText = "↓", textSymbol = "↓" },  -- Down arrow
            [23] = { dialogText = "↔", textSymbol = "↔" },  -- Left-right arrow
            [24] = { dialogText = "⇒", textSymbol = "⇒" },  -- Rightward double arrow
            -- Punctuation and Other Symbols
            [25] = { dialogText = "…", textSymbol = "…" },  -- Ellipsis
            [26] = { dialogText = "—", textSymbol = "—" },  -- Em dash
            [27] = { dialogText = "–", textSymbol = "–" },   -- En dash
        },
    },
    [7] = {
        category = "List Index",
        texts = {
            [1] = { dialogText = "1", textSymbol = "\n   01.  " },
            [2] = { dialogText = "2", textSymbol = "\n   02.  " },
            [3] = { dialogText = "3", textSymbol = "\n   03.  " },
            [4] = { dialogText = "4", textSymbol = "\n   04.  " },
            [5] = { dialogText = "5", textSymbol = "\n   05.  " },
            [6] = { dialogText = "6", textSymbol = "\n   06.  " },
            [7] = { dialogText = "7", textSymbol = "\n   07.  " },
            [8] = { dialogText = "8", textSymbol = "\n   08.  " },
            [9] = { dialogText = "9", textSymbol = "\n   09.  " },
            [10] = { dialogText = "10", textSymbol = "\n   10.  " },
            [11] = { dialogText = "\\n", textSymbol = "\n          " },
            [12] = { dialogText = "I", textSymbol = "\n       I. " },
            [13] = { dialogText = "II", textSymbol = "\n      II. " },
            [14] = { dialogText = "III", textSymbol = "\n     III. " },
            [15] = { dialogText = "IV", textSymbol = "\n     IV.  " },
            [16] = { dialogText = "V", textSymbol = "\n      V.  " },
            [17] = { dialogText = "VI", textSymbol = "\n     VI.  " },
            [18] = { dialogText = "VII", textSymbol = "\n     VII. " },
            [19] = { dialogText = "VIII", textSymbol = "\n    VIII. " },
            [20] = { dialogText = "IX", textSymbol = "\n     IX.  " },
            [21] = { dialogText = "X", textSymbol = "\n     X.   " },
            [22] = { dialogText = "X", textSymbol = "\n     X.   " },
            [23] = { dialogText = "•", textSymbol = "\n    • " },
            [24] = { dialogText = "‣", textSymbol = "\n    ‣ " },
            [25] = { dialogText = "▪", textSymbol = "\n    ▪ " },
            [26] = { dialogText = "▫", textSymbol = "\n    ▫ " },
            [27] = { dialogText = "◆", textSymbol = "\n    ◆ " },
            [28] = { dialogText = "◇", textSymbol = "\n    ◇ " },
            [29] = { dialogText = "●", textSymbol = "\n    ● " },
            [30] = { dialogText = "○", textSymbol = "\n    ○ " },
            [31] = { dialogText = "➤", textSymbol = "\n    ➤ " },
            [32] = { dialogText = "➢", textSymbol = "\n    ➢ " },
            [33] = { dialogText = "★", textSymbol = "\n    ★ " },
            [34] = { dialogText = "☆", textSymbol = "\n    ☆ " },
            [35] = { dialogText = "✦", textSymbol = "\n    ✦ " },
            [36] = { dialogText = "❖", textSymbol = "\n    ❖ " },
            [37] = { dialogText = "✸", textSymbol = "\n    ✸ " },
            [38] = { dialogText = "☛", textSymbol = "\n    ☛ " },
            [39] = { dialogText = "☞", textSymbol = "\n    ☞ " },
            [40] = { dialogText = "\\n", textSymbol = "\n       " },
            
        },
    },
} -- don't forget this bracket

return symbolDictionary