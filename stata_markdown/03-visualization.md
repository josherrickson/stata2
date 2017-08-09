^#^ Visualization

Stata has robust graphing capabilities that can both generate numerous types of plots, as well as modify them as needed. We'll only cover the basics
here, for a reference we would recommend A Visual Guide to Stata Graphics by Michael Mitchell, which lays out step-by-step syntax for the countless
graphs that can be generated in Stata.

Let's reload the auto dataset to make sure we're starting on the same page.

~~~~
<<dd_do>>
sysuse auto, clear
<</dd_do>>
~~~~

^#^^#^ The `graph` command

Most (though not all, see some [other graphs](#other-graphs) below) graphs in Stata are created by the `graph` command. Generally the syntax is

```
graph <type> <variable(s)>, <options>
```

The "type" is the subcommand.

For example, to create a bar chart of `price` by `rep78`, we could run

~~~~
<<dd_do>>
graph bar price, over(rep78)
<</dd_do>>
~~~~

<<dd_graph: saving("images/graph1.svg") replace>>

For further information, we could instead construct a boxplot.
~~~~
<<dd_do>>
graph box price, over(rep78)
<</dd_do>>
~~~~

<<dd_graph: saving("images/graph2.svg") replace>>

There are a few other infrequently used graphs, see `help graph` for details.

There is a plot subcommand, `twoway`, which takes additional sub-subcommands, and supports a wide range of types.

```
graph twoway <type> <variable(s)>, <options>
```

`twoway` creates most of the scatterplot-esque plots. The "types" in `twoway` are subcommands different from the subcommands in non-`twoway` `graph`,
it takes options such as `scatter` to create a scatterplot:

~~~~
<<dd_do>>
graph twoway scatter price mpg
<</dd_do>>
~~~~

<<dd_graph: saving("images/graph3.svg") replace>>

**Note:** For `graph twoway` commands, the `graph` is optional. E.g., these commands are equivalent:
```
graph twoway scatter price mpg
twoway scatter price mpg
```
This is *not* true of commands like `graph box`.


The options in the graphing commands are quite extensive and enable tweaking of many different settings. Rather than a full catalog of the options,
here's an example:
~~~~
<<dd_do>>
twoway scatter price mpg, msymbol(s) ///
                          mcolor(blue) ///
                          mfcolor(yellow) ///
                          msize(3) ///
                          title("Price versus Mileage") ///
                          xtitle("MPG") ///
                          ytitle("Price of Car") ///
                          ylabel(2500 "$2k" ///
                                 5000 "$5k" ///
                                 7500 "$7.5k" ///
                                 10000 "$10k" ///
                                 12500 "$12.5k" ///
                                 15000 "$15k")

<</dd_do>>
~~~~

<<dd_graph: saving("images/graph4.svg") replace>>

<!--
\begin{center}
  \includegraphics[width=300px]{images/graph04.pdf}
\end{center}

\newpage
Graphs made using \texttt{twoway} have an additional benefit - it is easy to stack them. For example, \texttt{twoway lfit} creates a best-fit line
between the points:
\begin{verbatim}
. twoway lfit salary market
\end{verbatim}

\begin{center}
  \includegraphics[width=300px]{images/graph05.pdf}
\end{center}

It would be much better to overlap those two - generate the scatter plot, then add the best fit line. We can easily do that by passing multiple plots
to \texttt{twoway}:
\newpage
\begin{verbatim}
. twoway (scatter salary market) (lfit salary market)
\end{verbatim}

\begin{center}
  \includegraphics[width=300px]{images/graph06.pdf}
\end{center}

Note that the order of the plots matters - if you can tell, the best-fit line was drawn on top of the scatter plot points. If you reversed the order
in the command (\texttt{twoway (lfit salary market) (scatter salary market)}), the line would be drawn first and the points on top of it.

\newpage
Finally, note that options can be passed to each individual plot or the entire plot:
\begin{verbatim}
. graph twoway (scatter salary market, msymbol(t)) \\\
               (lfit salary market, lcolor(green)), \\\
                  title("Salary vs Marketability")
\end{verbatim}

\begin{center}
  \includegraphics[width=300px]{images/graph07.pdf}
\end{center}

\subsection{Other graphs}
\label{othergraphs}

There are a very large number of graphs which do not exist under the \texttt{graph} command. Most are very niche, but the most important general
example is histogram, which has its own command.
\newpage
\begin{verbatim}
. histogram salary
\end{verbatim}

\begin{center}
  \includegraphics[width=300px]{images/graph08.pdf}
\end{center}

You can see a full list of the non-\texttt{graph} plots by looking at

\begin{verbatim}
. help graph other
\end{verbatim}

\subsection{Plotting by group}

All graph commands accept a \texttt{by(<grouping var>)} option which will repeat the graphing command for each level of the grouping variable, and
display all graphs on the same output. For example,
\newpage
\begin{verbatim}
. hist salary, by(rank)
\end{verbatim}

\begin{center}
  \includegraphics[width=300px]{images/graph09.pdf}
\end{center}

Note that due to the compressed size of each individual graph, you may need to tweak the options (e.g. notice the Y axis).

Alternatively, you may way to represent another variable on a single plot. For example, let's say we want to create the scatter plot and best-fit from
above, but differentiate the genders on one graph (rather than two separate windows via \texttt{by}). To do this, we'd overlap two
\texttt{scatter} and \texttt{lfit} plots in a single \texttt{twoway}, each with a conditional \texttt{if}.

\newpage
\begin{verbatim}
. twoway (scatter salary market if male ==  0) ///
         (scatter salary market if male == 1) ///
         (lfit salary market if male ==  0) //
         (lfit salary market if male == 1)
\end{verbatim}

\begin{center}
  \includegraphics[width=300px]{images/graph10.pdf}
\end{center}

Notice that Stata automatically made each plot a separate color, but not in a logical fashion. Here's a cleaned up version:
\newpage
\begin{verbatim}
. twoway (scatter salary market if male ==  0, mcolor(orange)) ///
         (scatter salary market if male == 1, mcolor(green)) ///
         (lfit salary market if male ==  0, lcolor(orange) lwidth(1.4)) ///
         (lfit salary market if male == 1, lcolor(green) lwidth(1.4)), ///
      legend(label(1 "Female") label(2 "Male") order(1 2)) ///
      title("Salary vs Marketability") xtitle("Marketability") ///
      ytitle("Salary") ylabel(20000 "$20k" ///
                  40000 "$40k" ///
                  60000 "$60k" ///
                  80000 "$80k" ///
                  100000 "$100k")
\end{verbatim}

\begin{center}
  \includegraphics[width=300px]{images/graph11.pdf}
\end{center}


\subsection{Getting help on Graphs}

There are a ton of options in all these graphs. Rather than list them all, we instead direct you to some various help pages.

For general assistance, start with

\begin{verbatim}
. help graph
\end{verbatim}

Each individual type of graph has its own help page:

\begin{verbatim}
. help graph box
. help graph twoway
. help twoway scatter
. help histogram
\end{verbatim}

There are various generalized options which are the same over the variety of plots. These can be found in the documentation of each individual graph,
or you can access them directly:

\begin{verbatim}
. help title_options * Help with titles, subtitles, notes, captions.
. help axis_options * Axis labels, tick marks, scaling, etc.
. help legend_options * Manipulating the legend
. help marker_options * Modifying points (e.g. a scatterplot)
. help marker_label_options * Adding labels to markers
. help cline_options * Options for any lines (e.g. lfit)
\end{verbatim}

\subsection{Displaying multiple graphs simultaneously}

You may have noticed that opening a new plot closes the old one. What if you wanted to compare the plots? The behind-the-scenes reason that the old
plots are closed is that Stata names each plot and each plot can only be open once. The default name is ``Graph'', so with each new plot, the
``Graph'' plot is overridden. If you closed a plot and wanted to re-open it, you can run the following at any point \emph{until you run another
  graph}.
\begin{verbatim}
. graph display Graph
\end{verbatim}

When we create a new plot with the default name, we lose the last one.\\

If we give a plot a non-default name, it will be saved (so that it can be re-displayed later) and more importantly, will open a new window without
closing the last. Running two plots with custom names opens two separate windows.
\begin{verbatim}
. hist salary, name(g1)
. hist market, name(g2)
\end{verbatim}

Names can be re-used (and plots re-generated) easily:
\begin{verbatim}
hist salary, title("Histogram of Salary") name(g1, replace)
\end{verbatim}

We can also list (using \texttt{dir}), re-display, or drop graphs:
\begin{verbatim}
graph dir
graph display g1
graph drop g1
graph drop _all
\end{verbatim}

Finally, if you'd rather have all the graphs in one window with tabs instead of separate windows, use
\begin{verbatim}
set autotabgraphs on
\end{verbatim}

You still need to name graphs separately.
-->
