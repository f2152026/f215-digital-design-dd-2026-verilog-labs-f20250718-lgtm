// cla4.v
// Gate-level 4-bit carry-lookahead adder, matching the lecture circuit.
// Every gate needs an explicit delay (constant is fine here, e.g. #(2)) --
// this is the default from Task 2 onward, not a special step.
//
// TODO -- Step 1: generate/propagate signals (one xor + one and per bit)
//   p[i] = a[i] ^ b[i]
//   g[i] = a[i] & b[i]
//
// TODO -- Step 2: direct (non-recursive) carry equations. Verilog's and/or
// primitives accept more than 2 inputs directly, e.g.:
//   and #(2) (t2, p1, p0, g0);
// so you do not need to manually chain 2-input gates.
//   c1 = g0 + p0.cin
//   c2 = g1 + p1.g0 + p1.p0.cin
//   c3 = g2 + p2.g1 + p2.p1.g0 + p2.p1.p0.cin
//   c4 = g3 + p3.g2 + p3.p2.g1 + p3.p2.p1.g0 + p3.p2.p1.p0.cin
//
// TODO -- Step 3: sum bits
//   sum[i] = p[i] ^ c[i]     (c0 = cin)

module cla4(
  input  [3:0] a,
  input  [3:0] b,
  input        cin,
  output [3:0] sum,
  output       cout
);

  wire p0, p1, p2, p3;
  wire g0, g1, g2, g3;
  wire c1, c2, c3;

  xor #(2) xp0 (p0, a[0], b[0]);
  xor #(2) xp1 (p1, a[1], b[1]);
  xor #(2) xp2 (p2, a[2], b[2]);
  xor #(2) xp3 (p3, a[3], b[3]);

  and #(2) ag0 (g0, a[0], b[0]);
  and #(2) ag1 (g1, a[1], b[1]);
  and #(2) ag2 (g2, a[2], b[2]);
  and #(2) ag3 (g3, a[3], b[3]);

  wire t1_0;
  and #(2) a1_0 (t1_0, p0, cin);
  or  #(2) o1   (c1, g0, t1_0);

  wire t2_0, t2_1;
  and #(2) a2_0 (t2_0, p1, g0);
  and #(2) a2_1 (t2_1, p1, p0, cin);
  or  #(2) o2   (c2, g1, t2_0, t2_1);

  wire t3_0, t3_1, t3_2;
  and #(2) a3_0 (t3_0, p2, g1);
  and #(2) a3_1 (t3_1, p2, p1, g0);
  and #(2) a3_2 (t3_2, p2, p1, p0, cin);
  or  #(2) o3   (c3, g2, t3_0, t3_1, t3_2);

  wire t4_0, t4_1, t4_2, t4_3;
  and #(2) a4_0 (t4_0, p3, g2);
  and #(2) a4_1 (t4_1, p3, p2, g1);
  and #(2) a4_2 (t4_2, p3, p2, p1, g0);
  and #(2) a4_3 (t4_3, p3, p2, p1, p0, cin);
  or  #(2) o4   (cout, g3, t4_0, t4_1, t4_2, t4_3);

  xor #(2) xs0 (sum[0], p0, cin);
  xor #(2) xs1 (sum[1], p1, c1);
  xor #(2) xs2 (sum[2], p2, c2);
  xor #(2) xs3 (sum[3], p3, c3);

endmodule