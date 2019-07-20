# learning-elixir

## Setup
```bash
wget https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb && sudo dpkg -i erlang-solutions_1.0_all.deb  # Add Erlang Solutions repo: 
sudo apt-get update
sudo apt-get install esl-erlang  # Install the Erlang/OTP platform and all of its applications: 
sudo apt-get install elixir  # Install Elixir
```
this setups 3 binaries:
- `iex` for an interactive elixir shell (like python woo!)
- `elixir` interpreter
- `elixirc` compiler

Test via hello world: `elixir ./simple.exs`



## Bits and Bobs
### string interpolation
```elixir
  "hey #{1+2} there"
```

### Anonymous functions
```elixir
add = fn a, b -> a + b end
add(1,2)
```

### Anonymous functions
```elixir
(fn a, b -> a + b end).(1, 2)
```


### List
Single quotes are charlists, double quotes are strings.

#### concatination
```elixir
[1, 2, 3] ++ [4, 5, 6]
[1, 2, 3, 2] -- [2]
```

#### Heads and Tails
```elixir
  l = [1,2,3]
  hd(l)  # 1
  tl(l)  # 2, 3
```

#### it's a string?
```elixir
 [104, 101, 108, 108, 111]  # hello, because it guesses it's ascii
```

### Tuples
```elixir
  {"a", true}
  tuple = {:a, :b, :c, :d}
  put_elem(tuple, 2, :e)
```

```elixir
```
```elixir
```
```elixir
```
```elixir
```

```elixir
```

