#!/usr/bin/env python
#
# Hi There!
#
# You may be wondering what this giant blob of binary data here is, you might
# even be worried that we're up to something nefarious (good for you for being
# paranoid!). This is a base85 encoding of a zip file, this zip file contains
# an entire copy of pip (version 21.1.3).
#
# Pip is a thing that installs packages, pip itself is a package that someone
# might want to install, especially if they're looking to run this get-pip.py
# script. Pip has a lot of code to deal with the security of installing
# packages, various edge cases on various platforms, and other such sort of
# "tribal knowledge" that has been encoded in its code base. Because of this
# we basically include an entire copy of pip inside this blob. We do this
# because the alternatives are attempt to implement a "minipip" that probably
# doesn't do things correctly and has weird edge cases, or compress pip itself
# down into a single file.
#
# If you're wondering how this is created, it is generated using
# `scripts/generate.py` in https://github.com/pypa/get-pip.

import sys

this_python = sys.version_info[:2]
min_version = (3, 6)
if this_python < min_version:
    message_parts = [
        "This script does not work on Python {}.{}".format(*this_python),
        "The minimum supported Python version is {}.{}.".format(*min_version),
        "Please use https://bootstrap.pypa.io/pip/{}.{}/get-pip.py instead.".format(*this_python),
    ]
    print("ERROR: " + " ".join(message_parts))
    sys.exit(1)


import os.path
import pkgutil
import shutil
import tempfile
from base64 import b85decode


def determine_pip_install_arguments():
    implicit_pip = True
    implicit_setuptools = True
    implicit_wheel = True

    # Check if the user has requested us not to install setuptools
    if "--no-setuptools" in sys.argv or os.environ.get("PIP_NO_SETUPTOOLS"):
        args = [x for x in sys.argv[1:] if x != "--no-setuptools"]
        implicit_setuptools = False
    else:
        args = sys.argv[1:]

    # Check if the user has requested us not to install wheel
    if "--no-wheel" in args or os.environ.get("PIP_NO_WHEEL"):
        args = [x for x in args if x != "--no-wheel"]
        implicit_wheel = False

    # We only want to implicitly install setuptools and wheel if they don't
    # already exist on the target platform.
    if implicit_setuptools:
        try:
            import setuptools  # noqa
            implicit_setuptools = False
        except ImportError:
            pass
    if implicit_wheel:
        try:
            import wheel  # noqa
            implicit_wheel = False
        except ImportError:
            pass

    # Add any implicit installations to the end of our args
    if implicit_pip:
        args += ["pip"]
    if implicit_setuptools:
        args += ["setuptools"]
    if implicit_wheel:
        args += ["wheel"]

    return ["install", "--upgrade", "--force-reinstall"] + args


def monkeypatch_for_cert(tmpdir):
    """Patches `pip install` to provide default certificate with the lowest priority.

    This ensures that the bundled certificates are used unless the user specifies a
    custom cert via any of pip's option passing mechanisms (config, env-var, CLI).

    A monkeypatch is the easiest way to achieve this, without messing too much with
    the rest of pip's internals.
    """
    from pip._internal.commands.install import InstallCommand

    # We want to be using the internal certificates.
    cert_path = os.path.join(tmpdir, "cacert.pem")
    with open(cert_path, "wb") as cert:
        cert.write(pkgutil.get_data("pip._vendor.certifi", "cacert.pem"))

    install_parse_args = InstallCommand.parse_args

    def cert_parse_args(self, args):
        if not self.parser.get_default_values().cert:
            # There are no user provided cert -- force use of bundled cert
            self.parser.defaults["cert"] = cert_path  # calculated above
        return install_parse_args(self, args)

    InstallCommand.parse_args = cert_parse_args


def bootstrap(tmpdir):
    monkeypatch_for_cert(tmpdir)

    # Execute the included pip and use it to install the latest pip and
    # setuptools from PyPI
    from pip._internal.cli.main import main as pip_entry_point
    args = determine_pip_install_arguments()
    sys.exit(pip_entry_point(args))


def main():
    tmpdir = None
    try:
        # Create a temporary working directory
        tmpdir = tempfile.mkdtemp()

        # Unpack the zipfile into the temporary directory
        pip_zip = os.path.join(tmpdir, "pip.zip")
        with open(pip_zip, "wb") as fp:
            fp.write(b85decode(DATA.replace(b"\n", b"")))

        # Add the zipfile to sys.path so that we can import it
        sys.path.insert(0, pip_zip)

        # Run the bootstrap
        bootstrap(tmpdir=tmpdir)
    finally:
        # Clean up our temporary working directory
        if tmpdir:
            shutil.rmtree(tmpdir, ignore_errors=True)


DATA = b"""
P)h>@6aWAK2mt3s+ETYTE!+SB003|S000jF003}la4%n9X>MtBUtcb8c|DLpOT$1Ah41?-hIp`nx}hp
m3l+Qwf~W^?rG#xVX$F$rWoBZ@zju=ohlODuk8d8Y;n0JQk^C8`kAW3FNOTQfQ7L%W8B><O$dW!~346
%yH+EwmGGk1Q4fKxu%JEtDpTT3kGmz$HBH|8K3*;~{52AcL=5Y4{<aIV?S@zSCKzhzkDspne>-ReZ-;
L0t^9oI17zE)oLZo;r5H237;3aejQZYppYi8hEvbwsa>shE#9d)t>L4;N{%C0ERr0sCBRp^U2Mpq<eK
_UZ6v3-1gvP-ggH&Z{!Vap|*9W)^=dgU>Oq{>oUd0`hL@-+&h4($KMxuo3u0Z>Z=1QY-O00;o*M%q#%
8{@xi0ssK61ONaJ0001RX>c!JUu|J&ZeL$6aCu!*!ET%|5WVviBXU@FMMw_qp;5O|rCxIBA*z%^Qy~|
I#aghDZI*1mzHbcdCgFtbH*em&nbG}VT_EcdJ^%Uh<#$rfXmjvMazjtt+Y{4fL(0@tjn1(F!nz|6RBO
jou<lHavpt2DsnN~{0?3^aZW|#k1{K<zbVGw<F9gAoI$2%Q=!IwHz3?Ga8yfULmF;_^_Efc89djgN{>
LCQKB%tCsnf_O;(TkT9D!5I2G1vZ<eHSH;T&3P=(dl1Ul+n}iN0$4eg8-DWoeqjlH$Ojn(A!3eMku3i
Yf*>WcORK<*}iONjWAr8Zm1&KuL0jC{@?djd+x5R}RGfYPBawx08>U(W?WmDk1T9S4?epCt{Z(ueTz)
EC*E`5mT15-&2~-DsS-6=uU3I|BmObEPJI*Sr)^2!Om@h-$wOJl_c@O>A_3OHg5wqIeD(E7`y@m0ou*
N^~8Scf|wu`N_HtL5`*k&gASg%W(oQp9a7<~IpnR_S}F8z9z|q{`1rb)-o!>My0eex)q(ByedFLGyO7
=Ikq8}(HcH6i;acy-%V$hD`fEosH<F#RjvR|Bj1`9E=F8_#Ldd3;(iLXg4(#CUYq600w1FS!F^DDXW$
?A?W<%x`1Go!_!Mo=`yT9C6$GfF^02ZS8gBiIDv=G#cRjO3bn3+}$P=T2Wt8GE|SP^4`jHeuCMeAZ0b
K3QoB})QI^}#>@wgA+8z#{H{ToXOd_?&uMj~(yRVmD7BE?-`X6FU!78rkLs#HE1jqSOWnjp~Z3(}j4w
N{#<0DmEaww2fbN$l@K=F!>KqO9KQH000080Ov;9QhyTf4Zr{Z03HDV01N;C0B~t=FK~G-ba`-PWF?N
VPQ@?`MfZNi-B_Ob4-5=!Z$M%;t!XVKc9b}U{5?(?Egj!;iWEo#VY8e`cO+3psdiM#D?U$24DrcGE{Q
X%^A1rwho7bo%%^4nEOe11`ih5ds}r~C4-D(by*bnzy~VhcmspFPs+92he4iKm495?R6(6IB9*bzqWO
6Z``e?dj4>$ei>cuLo8^bh>J0qwmAso~zg@9MQ{TAMQ=}M~B1K+Woqz5;+g_LK&{q3XhT~awQHE!$j2
T)4`1QY-O00;o*M%q#g(({`M0RRA+0RR9Q0001RX>c!JX>N37a&BR4FJE72ZfSI1UoLQYZID4r#6S#%
@AE4{y=-A^FM_(T9zBU(ye&(aZPPZ=&cq~D`tO}~ttVk1!{d?f<+Tz=u$d`zKqE&ncp<etys=RXesJz
rX5ylvU?@o~CZj<M3LjWorC3jbCO+tDg&PR*(>v!HY+>{ic3wI?zQ%z0!2v9e1jPgFHqL3mp48-g&f)
e65@|JNS@zzOLV7HyC|}q>8wKLfKplg|0YPgaHU;awCEg60;tg;?5NuH})akx;9a-Vl&vRPgn})7*Xw
ZDRXb*}Ay&3DFEIYD(x)gOBOP<-6se+PJC)D!(?(w160<N=Nn*6UM3??(jr0Q02^(~$m<r*bbH%a&t*
RFE+15ir?1QY-O00;o*M%q$DB)oR^3jhETCIA2$0001RX>c!JX>N37a&BR4FJg6RY-C?$ZgwtkdF5K&
bKAxdf9GFur5*sd0H$uHO@|X^V#{=_sYlXSaxy80gMh$Mx(Wo)JAf4J@&Df4`vC3$NO7CDRxczEyL)@
Pd%yjF=JWaMmK8Z!l?TSFa!<>Kw1VbjS8>8bRiq88N|Lvnm3KtsOf+PR9Po2CpU-DAwy!JRkgO^j`q&
g~YgUTt?hdK+&q|nYb=urpbmG)KK?z5m*5>yoR_|CrXFFc)VTYoi8LA_QetyMs%4z<FWsRZ%S)j;{-5
H8I+9bH2P|urFO*`&eo@R8LW)HWp+C9f}8iHT0SIPOi)%o8qE`JQkMMHVIEvWw1R6Hc_!5|^Is!^@92
+0kFpSNv|R8p*xTeCV&4z$cG9%qy{Y{$$d$9p)!n5urbOE?u(%d=kN5A<Ix;}pFVlAkCSu<JRTw*Ui#
<mZY%fcBt5zpLR)5;SCzkW}DuQdF7rthF%%2XZ(>oE0n<V22VmF#J_b%S10u@fdl+F+4;MI6726INh;
FnkTR#^is<y2Ev5Awqb>cMZ2we1qSHEW@%9*{qobS4c*sC&Uoib`27ZKmx0?(A;HJ+Gy#L<0)lwwI(s
oA@HZhG$mwHTL(rsm6l@AVyDhHO>RY)un_>LJ!=<?hF&z25T=SEpO!wf8U^bg&MGD7DuBCYvGr4h2ci
=HrvL;D<L5p1|FHNA-!oM>a$_wI)h6g12o?KQX?Vch_j2y5#ez*?=ZQ2^1yiE%+;MuZL8g1EM9KWN$K
d)>&0@kWTj7K2LrCOpOig<M;*rWEe7dniGl#AtOZ<`A0Eu>N*&_jS&D_=T}VC{*Fv$_%9#?=tw1vL~#
MLVi|X(X`e4?P;i`s+R|!8d#+O`CC=HZ&1UTIOj1mP^3PzO<vc+G{ZEM%f!+?p!jEl+1e`jEp%#6v3+
%E6?5D({9NV3KaoT83b?+Ul_zMX)4kHS=Mq6OT{VTZCN7hV5mtc7XS;aD9Dy7Fa{1*!p^Y7dk6rTrIs
Zjnb01@W23qJR4}500gZAEpT3O)L5yHi9H<{a;GkaWJZFG8P0LGLW2H+80wEB7RkDA@BbHSICd$n%i^
<Qxla`)N8Cqbf3?$+9o&gkqK?#F=!5(OFB72$wir{wrHiD!DcpyKK-u&u>paJfxl!%$Y*zm1;a$*z=1
HSYXNzgsv@?7eaM+R5LK?om#VQG0gLT?8MpN#^Reh;)G9%+fU0xcZ>vtp&M>0%Y@^CSWHV4NjM{0U`s
{13;J-(f(1?k@nG3vyX}P#6zTu&c=TOX7bMlD}EU>)F?!D~B|YG;B{n?R_ogo6#kg2h~|M{s*hy!l$q
G2OW>|ki2-I1j@61+PQmSRgm3dtg+G<o!=GJ)}Oza5A?#nPrLZYSwnrv6e?Z_H7qL*G-)dB79DdzoQg
z(h#v$4A3C<}RhDk)U{n?}RxLBQz(U5Ff&%=mD;(-v9s9PadzI5#boXf*pr@dDjLTh8S`MPkbts0Olc
3_)A1~g&NmiFXLE;2!gKDQl9V1`f^0wb0n7MFi020H?s+QaheT4GR<RIUTV(Nr3QU;c9Oi;*V05RcvW
ySYt;Q_i=5WPiu@`9(e)A<IqTW@;PVO1poctCD}|MTRik~%pm#VOt+n)?M1`mSB#Lt3;{K)emY*Hti1
Yp8&7U$L1y8BA~(9b-s37Kd53OmIfdThUZ|_K6Y!mjnXOj-m*HQb2`7;u<b3-dG4(_<3J}iD~Xo)_6n
+-87TM5=1bd2e?kj)#ZxlttlTS_)y}Ga}48tbYup}*+;TKnp8?dFI&}{AB1+XXJ6be1NR}j4*%z3%tJ
aWYBa_h7WxQY6uv8R;5?w+KVT{tP`N;eMXej{F1c1EGhT{o2xeG3dJ-IW^#B}e4R)rDiF1lc-ygxE=X
s;Gu1yN1nM2tZji}DZTL>a3_H$m<+K-X)qeNAJGFi37BhHF5s6tbyo=+mtwIQY${JLIjM)VJ5bu3j0h
?KPPgAt9qW+)0`;<Fu8f8bxn$pHWGX`JRcexiSr$F04V*7xy-dJkKx$!$h4tSZAPQu_>@Jqiqrp}~R)
D~)AN*?B#=vwUc8KVqF^Q`Psx@#HO0r|66{k}y7kIW*qNkpdF|ctfG8g<K9^gqm&J)q9LiMBSMJF|2M
o7?UWb8#tPed7P*+xcOv6LE49gTAqFA#;=aRu@{FoG>CVY*C2aXQNFZ)gv6-2bQ3`k*fj&iPVzr08Z;
)QP%lB1GJ<Q&ybFv7UBY0SsS`Sic`j97zq);giTe7N+jm!&mscNeRv&IIZdd)9q_6?KFM2hCI9bxhk*
dfOhsc~@t@iCHF`zZE>tYS}GL0IFSkwh;3~CEn2UbR{PYq;8bLm_#-}GdbvD!KZ(DYrCDg_s$-$YlP7
%Jg_bZEN;@m_k9L{CZWl(uAlaf9Yj7Me~-^tALbOE7xEK8(yjYK=3f^=p8L)ni8G;%4J89&l<k=5txx
t+rG9*t0Z6KNa0^9FGGWgYuAa6|?APS(3?%>;z5>p4<z6km_~xXdWR&kCDQ1d0o|hx83-P;3VTY{<Y@
C=BnGccUE>!vxmg)()9obmc*1v%v4bpu+lhke7L@$&02kf2O+kwn~j_=O2XbH(39vE{m+;Wg{ymnBM3
PkL<qLkS|By4cEs1s4h2j<rT|ZQAeAKz?k)!6_DqN;MIoE5Sohs<4GRfdx#2UW<hkcLV%qNqo&Er7M_
>mMR0l8=gntb`P3IKY`Y2+Y?)lcp6`NGZwIC}9o{qG^kulXsmJuP9*K0V&#lrFlsg|*%RGj_!kjt?9|
I-FrXUi#2hlfw<=KNVwUT*B(PEAPcZ9{XaKHhckxDo#ZP^odL1vl=*wBNTEWf40UrH6dkUL|mNoPVH-
9Rn=%0SL7Q>@<G()hMOg$>pH0UJn)MRkJG-)db4P>p)^Rj&=HY-SarN%yFk4Uzwk>pRuN%E65l(4Vc%
LtxDEBy6k7<_Ug^mf_$KRXw&5&j%<r6d%*V*rR*-`n~-nfzY@{b*qX%TT4pL-8^|hPBQv7M-TN08IB%
(G{g;>Dl6%ktq6eC7QdB9vK+;VuD+l7_gb*OFB1cMg5M7v9%-D1epgRYDf+{)Lp0Er>QPzBNAPwJwbT
i3r_$r53x(M||S2DWQ=+qSMJ2`~=c4F9tLn$2PVvt%bF6@o@!X3AMMamh70~f}sc+_t8pBiINO(mYcr
c+yv(L-O~(YkYA$1-J<kJt5$bRX!d=Lb->VVQDrUk5#Z2wQo1zlXrHAae(B=HVpd43H)q+}DMflZ8WY
u{Q1Cqj#&G@w%-bMi+ggS=*==i;e?`rw=?VC!>hn;S4D1GB;N2QB+n@3y`CJn71$nW@M*5lmi?`C}$$
|vL!O%X>IuIm<{fSddr1P$7;93*Ru!uo*rlcxbt2A>g&zw^~WFG5J!8MshSrZtS$rdw(7QIsPn2YlSO
PaQht)d#j-e=pTTHI4ZQjdQQAOyQ~r-#q2XYYV62|*JwU(6BYzyw1IpC^eAM?6X>sqlgzJT#o-hGK(%
d&X!cjkaixMNn`w|3pGb3L$CM_@UB>DvXn(c#rb;88@3~Mi9pk_}BCBtT1F99`A6G??ex5!^EHe-w$>
<~%zNODEM1shrdt?kB$=Y|6YrsNrfMZwAk)XO*&J`!Ae{@@YPMUu`7rHqYbXOw$iiN=!K@D>{TJi+DP
5UoigBn9F4v2kixEfTJ2bxaVw;68F%P-w8GME52DI&Vr6-e<@HD)xU%0#HWgmdu_Y8$QvevoX=~ob;#
eg>V=#Pp&VnlbhRDmv3IZzq(u{=c^C5^M(4q20!R$z}?8z{2zg@aZ^?(dd)r0;BCK;>V<}MsXs$kr=|
0&e>HSjUDd<aL;i3f=w2ATg8D0}YFP<IvV)M9UA`c~h#7JkzTfqJs0KxU->_&T;eUE^;GQ;vOI5b@e{
HS*n^uOWOi);AF80vjqjEG~ab9ugzW)tSO9KQH000080Ov;9QlOryMnDSy0OlqD02TlM0B~t=FJEbHb
Y*gGVQepBVPj}zE^v9>T5XTpxDo#DU%@&!tXwGCLy)GZ0T;;SHcf!dwYa3nhs8pmCE8|I7FCj3$9K5@
-kG5!l9Ii<I2_R4`NKxy%W&T387lMn{0%R5f_>mM--^Ac?QA}u&t`JpC~et}n_VT>{p%N_>i)S>+pVm
({i`ywjaGYRj}45nZuE71OxgFcuqnHi2LArDu~OB%O4&zYXKqU)n=HQ<b*XgL@Zydm-OTc>>B)TJ+my
-L3f*V{fAgB}MLcpZv;oQwQEaWO29gD@RV@o%$)5y~3z;Fpz-1=B7J@h)_Pwv~VNdyaCq(sDR)V&k*t
u7ws7$s|de3cMsM=~(^+ev%=o>fq!0t-ccm1Agcz$5%0U7Go5_hK-lL|5`_Dx<&J*XGnzn5ARR%x&oP
Qz?|C+pIjr_yS#&4$}uZdDFrvl)7Z&}`MaNVXOBn#PixRGsIG*=$yd4a?ENfR(}~<zhKw@Oy?XB$g~e
x4AJ^rwsnwF4*(G;{&Y$7yVJ#R@aQf7++U{nH_)e;w4iX7(#mJW%`(*Gvf{e?4b8%WxH=oQUX!nJHHc
0v-+f4a3&)ft~qGHtde;;PuYAqU!+Xbrqv?nrjU|WE{L9X$9M6OxziJqiMjxLBy(CnUo5hn_*%-XFg8
J%i;5e=DCCyCB(Fh=HAuz_@JgD0&Kj-mWho4}DMn}68ArkhcoZwS<%|r29%6tn>wZfVV(+%0iI?mX?A
J<JRE>pan##r-Vn1C%;4-!T0*B(Z$Xz=gt%9@n(hh|1x0axEWO6Mq324Df$L9Hic~z-{D09bvS+c`U7
Q2oggQssG%8aJ~mR4<5g58x4$l))!AO?;XjMpW*FsjvsfEO)jyQ-^We;$J<ZiQL&MsOM=mjpkTHqR3y
s!i%OnT~Xnj#=;gH}YX}-$;Fw_-+P|{z27Z*k;-WVq}pGEG&j8P`Q9OtCjT}G4KRsGK{@U8t|cHnDQG
@ip+0W#oOcKap@>wtwvJEi$@xO)uR#bm^r1*VCBzqXCI6-XSVq-V{uO%lC?F&b`sNDu+?gGL|{?KKe-
c|@)S6pHJy1eeoh$<vn?42%NChySOebj4}mF9JO9K7@GoxJzBLwHe=y1yC2MfCgS0!Z_K?mjIQX+*2V
PqYtgWa8q#^-s%pjxUP;1}~j%#%n1(3N?c7W8N>I>WN49I;!UbJ|Q8`1gy{o^&TR&acmz^dHtu)N;`w
=fN*0J1)$^O_cKG~W^y@boaEhT{qhDZW-M3a(5LhQOB7FIgCvpD#(rSS@l?1nkLs^4{KZ<5p2Qz!Jfv
A!kPirL%|WaAp~W|8VwAOzRd)Q9m*{(zNS7y&eb7&Jmu6tLFpZlQcr(zORd_Ek%e}n8Pr8{srO?CEUv
zo;n<ZmKY2jx~F1=YJ~GCSyj*10*wgiumndn&JWkEganCoaI+B_SYd<?0y3p&03BhDR?gzh5lmALr^6
5=2m?i~$(kdoyvyh<)P*`7`Gs=|SNe!re{dm44z-7HkZV~<dt`{~vVg$O+Quv|FSj63yUt+oWpix!B|
wf#X$&Ok%fG((+pDRE-OR^`kPI>&43g-Xt)0-5-Q74AZqM$OlM(|F$WeHbEgS;Cki4iW=Aw?&HiR5_A
2U!gE3N~2Mii|^y+Fx_>~FDpf{~HjUtXnPO6%xzta}>$#wyDzV8Avomw^65_t>?DLAf-Ju2^L39VE|t
+!oozbVl3rJBTkpYFOw)2k{m}z=7hT7zKwvkS>CV$DjiLTZLF|Q1s$VhN}S(bsTwQV-&<aOoICF(P_c
4(dRgf)r4MD6Hu#QQ5Ee!AY+)MTyi5{Z3)0Yd`2sQ9v&7@d;8H#)aS1oC)&;O#ckS&dGliV(!ac1zVa
`xmbbTF+72HQsYxY*$O8l?!WxwNh9q|#i|b0x)g}VPzCb~r<qH&0${|C#k_U1mQ8L5aIRXVrPgb1f=G
02$ei&SY={4db&ZwPwZUT*YWN-q9U<;9tfIuwPX@*ZTHmG0>EhzdSa<F?yrm*e|=iZ>`G`E2tLELuYA
pZnDfNG8^O9**{TzM!5Hc9YtbTkIya26(3g&m@?XO_pTWxT<ZpCrRjN(?R*W1sbVyyH&Ue<FP9J2w1<
UE5GDDcK>Ecjd11Km^65>KY-Yfmtpg75$*>`+ZZ<#f2!Zv{t%L*B#s5ONis)%>`ZX>v_Kp{W<idG+fo
+W5m!906ezC;89rR(vT<w=_kH*OHXMm%d#$<gX0H{8O+gm835Yip{CGrptgvwSp8Fn<qoJB-R*;cKpK
G6<*!w0*Svm|I7c@O)W;_Dcj4RF4!1zsCDh?M)=dlSpwmLTUR50c_*H$^)7q>jG*=IFc0Ugt$>M(!1A
*cwy$;*I>)?c?Qimw~L%5jNM}~lzz#z2;-9<up+CU7kB$*1Rfg{x^fjM|V$X1)S>e?F5=K<#`rS7mUw
@r`%k<3m)3iZ5x?mBL;xu6aSHeq1HvA&s?bSZIkok&xGa1w8G`rEvoR^9H`Fod@@jwj!WfXz5SXH1En
EJ3F3#BROzu7LR;y2$^uB4bzCHe=ak7wBPMRH~muO&wnEwRoh%L&3cV>Z}LcJ$!~e-)7%JNaG}k2;AZ
lON%=jb7we0j2^;4iU!33)<O-VJO<0IyWB%m)G3U)-kC7vTEMU<Asdw0<RS>&$K3%@`snU}$UjIBciT
cx^#JWeuRe0A(>bC?M^x5Mx7KlK3w!x#7yOKUB+u`>7!B7op>%0A-OyF3u*Xhf+9{hmYV(x+IfS8qgp
x1@8)IA(vUd`>#0ljL&Rb3I$CC(_hOo`qu2YD6rpx6z@{s}bMoc|~eLZ-K1+n@#MLI4-R_^LM@f<Cpm
F_<O<R$(I@C2zv)~$#p9IhRyhK|eVIQFO28F8iuxQp_v6zg`IOlI*nf4{AvWr17}RtENsOZV^(#6Oh(
`RUE267H@9iW^0_00lIV%YhJP04<@t#C%0I|HfqV^dzCszRqA#5KQ(go~%k_&M9w*lO&Fq6QK4P`;L+
+RlMMm!`)$Aa$W2$g)N@O#1tV<_MJ9O#5Q1xQhd$#n2TceAJyms^O(yXQSM@r0K7m?2>(1i6TB<Dj`F
>NnRE%5l#<}HPZA|$&woIFvG6GJssYRqfXFeb4DsZ6&Q<h63(A7hUO<sP)b!a(X+UkGk0!@QvF76d^D
%5md2aZuwu--~#r}g|)mG6bw(RO(@2)=NpWj_wUFUCJzj=2RTYX!pHNcN!zNe40rTbtNw6^ClZp;`NX
d-U>S?a1D(rcuthim5PN{ML5SP0Ev#aeYA5dt+6mxNDN@pS@Ccrq~UUk0|%w<4c4Zzirr7;NHF1WP$X
*ah&D#++I|AvEeX;%$M;yj#r+v1!35pe1;L7=b*R2DnY&sa?7ze<W%IprL^SK*XgB#{NEgqgn)u4*MA
5FWk;HQXBjK-Z%9h;C>l>fXZDK=x?MZJ>+?=M|4Q71D$aenRs@uq~D}>>oVU&ptF}d(eaM+-<F9$8&6
{5caD6~M+D}l@K!AtPELT65gVfmN>34@aQa0lteK;+U~lGYYH#e2so$B-2g1G_MBhIBg_K{=f1-H&iY
mN8Mtx`0o4R=J3;~d%aFyLPt3>0#O`IWvLeSHLyi5ThG_S`0+aS8-5*Fb9(87))dD@?>$W+mAXqMG^F
dUm>HL^}n!TTo=x#O;@3e>-!@=34!#O+7}m3046<($N$wDE_K_${x@NMzhZrR={@O9KQH000080Ov;9
QX(>(Bl!;i0G%}e03HAU0B~t=FJEbHbY*gGVQepBZ*FF3XLWL6bZKvHE^v9x8~tzNw)J=a6|4>i%c!I
4b;Yn6@U~o&y9Jj^g5*A0c!sK2bj(GT1X51U3$nj`?>&+dDap=V+W|9*#+Jy($M^kpK@j{@<V$h0kx3
<roUM~Qx#4S`S4{D0Qw|1K#hSB<%eBahthm`u1_vxp)_lO&p<?$^R29#e$k~Dbv8BkkieS-Ql5KF+NB
qkYrHX|}DxR`?QLR{_fgG?~zJ*0+@B<*MuSITGh-#<+i3Q;mnlBOV8WD6UlDtAJm=gI-#@T%#Q<ieIk
OIKmu=^F4fclCX)a)JM!~;T(m5GpSfk!W8u^t3LFc^q+S;)$4DHEx<w9m3)kz~C2b#nv9*q?>6-_%wO
5FV?xCE{ToALiRJI}(d(%uaxw$#urZ>{KZDea7$KZ%g=jULuA`HfHZPB^;&Ul%kAck;5i<74gptPRo>
q90C;>^B8$7Wg*Ai=dXb~KNXuSJu9kL{Ip0?o{k5jzH>H}$m%1KvP^|kJJ&_PyE3Wl@=qscN9Uieb}w
HGwXlnMt~Qd#0DlbMH|xRRGP&1SUl9G-)MH1~e$Ae-s}(?6C3!k{EAkXJ7?Oqo{tm`WRdO^K{B(Zy`s
7Xg>hS9L?C{+&tQ#VBA{Rp@mKJTsGsX2AJa;%aKKmHs`m6Zl&Dr_o@eync?zmJyQGgw+cvgbwJY(-c*
lyuK#fqgbbqWO$#4(XP8t5fcx~*p3hpXeuX|RFY06g<~#y;Tfu1dZTOR=DJZ%)r&9iC2uo2<A_GQAdV
zf~1qvri)BwCd{Q{qZzVqT(*J*+(I(O_I&oaegOck&~Kx;NhavfaiD3Hrz;Dyg0dt4f$T5oF3cd@yEk
U+5##?xSQqf5g$=kLEIGx+WE)h%gd9a<M{mY==c(7K(vVTy~gGjQp0}7yV&n=p7Rxt9(+7JJvoX`&kv
8{^Rv@mYJe^XA2<RW3{ZPXvWyx>H@rHfXJH(pk%?oF7hvhx`TOGudzWmlIRpNXJt;{4KC`5%z}9Rkcv
`T$kn1E9|K@055CT}ilrLFazaY3FS+L1KlNL+_pMZ4(>0}3gMJc5hV2R!(x7=7slq3a)0%<AvO(IjEC
5f0SHgdsP$Q^1Il5FtE0;0bJW=emethk3;jv~p+ELrey7!Sv6cresEKn-Y>suEc#w8Y`?0A6a0Td-!|
Pv&@yBG0z0lza&!%?hx2Kp{mNBzO^-Yhypq^hkvQZ@||e5iyWzFG0{g&fv$~;ub^!P`W~ggZmn+I9j|
IsII_)0eWHmhUoB?Z&_M!MVo=1RRR#w0^J-~74l2g*MJp47Dg=aL0oXTN=n7H#fII3?}07Ac9e;sR>$
b!5zI&qj7rkKHJeA#5+$J07p))5M8MXr)egOzjM`L;RGEn?1Uih_%aNfe2yg6}o0!~i*d{B{6n)SP&E
mKrucoiQhJmC(03~NN%7u!+$giS*6(SGu+nBX1YI8lfGs7jwDdRmNv`7{@J_ymq8o8Sf=#RSu5rFf(Q
^C1LC}`sIj<YjRki~W%h|YER=Ms31#y1@PXE++y3kbcgV~Fr^v#N!LexZ@c`TZARVhMyeI0Om<I4Kx)
Zt9$1B;%n5<(j-nA4kWnrDzW)Y}O|HyuA)BDy-|$cig_F+4=~=xyV4(eIcJ%!}JdzI!c%mbGE%^q=n)
_7I)y=6sRVnKw=4Y3zaWfEI>^#$U>zhK={Lt_e?}eklwF^Vj3w}1TMT%V7D6RhZiSc;USQz!2Bu}*sv
30M%2ClO!PL>UKXAyI#*SN<mBLW(Ax=i1q4t4tO2sgQ?Qh<LCd@`JodD}MK;O6UMo_k1Tg0w2`Iz`1;
eAS3pfeCxOU7QVUNc60}VCE*&Seqx|uVcs